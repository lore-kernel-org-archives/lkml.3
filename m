Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaLFRJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:09:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:25668 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaLFRJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:09:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425935635"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Tristan Lelong <tristan@lelong.xyz>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "standby24x7@gmail.com" <standby24x7@gmail.com>,
        "askb23@gmail.com" <askb23@gmail.com>,
        "Hammond, John" <john.hammond@intel.com>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "Wang, Di" <di.wang@intel.com>,
        "Pershin, Mike" <mike.pershin@intel.com>,
        "joe@perches.com" <joe@perches.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: replace static value with define
Thread-Topic: [PATCH] staging: lustre: replace static value with define
Thread-Index: AQHQESR8KlBrIWFQ5Emsq5wS4lxBAZyC3W4A
Date: Sat, 6 Dec 2014 17:09:29 +0000
Message-ID: <D0A88610.CE1D7%andreas.dilger@intel.com>
References: <1417850172-17092-1-git-send-email-tristan@lelong.xyz>
In-Reply-To: <1417850172-17092-1-git-send-email-tristan@lelong.xyz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.86.108]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC922F504A65C646B4B1A8EB532350D3@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/06, 12:16 AM, "Tristan Lelong" <tristan@lelong.xyz> wrote:

>This patch replace the value '80' used in several files in the lustre
>source code
>with a define LUSTRE_MDT_MAXNAMELEN.
>
>This value is used in 4 different structures as the maximum len for a
>service name.
>According to the comments, these names follow a convention which make it
>possible
>to use the same define for LCS, LSS, LCF, and LSF names.
>
>Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
>---
>Note:
>	This modification answers Joe Perches suggestion:
>https://lkml.org/lkml/2014/12/5/107
>	The patch has to be applied on top of https://lkml.org/lkml/2014/12/6/17
>---
> drivers/staging/lustre/lustre/fld/fld_internal.h          | 2 +-
> drivers/staging/lustre/lustre/fld/lproc_fld.c             | 2 +-
> drivers/staging/lustre/lustre/include/lustre/lustre_idl.h | 5 +++++
> drivers/staging/lustre/lustre/include/lustre_fid.h        | 4 ++--
> drivers/staging/lustre/lustre/include/lustre_fld.h        | 4 ++--
> 5 files changed, 11 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/fld/fld_internal.h
>b/drivers/staging/lustre/lustre/fld/fld_internal.h
>index 8806b60..6125bbe 100644
>--- a/drivers/staging/lustre/lustre/fld/fld_internal.h
>+++ b/drivers/staging/lustre/lustre/fld/fld_internal.h
>@@ -111,7 +111,7 @@ struct fld_cache {
> 
> 	/**
> 	 * Cache name used for debug and messages. */
>-	char		     fci_name[80];
>+	char		     fci_name[LUSTRE_MDT_MAXNAMELEN];
> 	unsigned int		 fci_no_shrink:1;
> };
> 
>diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c
>b/drivers/staging/lustre/lustre/fld/lproc_fld.c
>index 74b4db9..7a55941 100644
>--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
>+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
>@@ -96,7 +96,7 @@ fld_proc_hash_seq_write(struct file *file,
> 	char *name;
> 	int i;
> 
>-	if (count > 80)
>+	if (count > LUSTRE_MDT_MAXNAMELEN)
> 		return -ENAMETOOLONG;

Sorry for the late reply, but this has nothing to do with an MDT service
name, so using this #define is misleading here.  As I wrote in my other
email, this only needs to be at most 8 characters.

Cheers, Andreas

> 
> 	name = kmalloc(count, GFP_KERNEL);
>diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
>b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
>index 7b7457c..305ecbe 100644
>--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
>+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
>@@ -105,6 +105,11 @@
>  * FOO_BULK_PORTAL    is for incoming bulk on the FOO
>  */
> 
>+/* Lustre service names are following the format
>+ * service name + MDT + seq name
>+ */
>+#define LUSTRE_MDT_MAXNAMELEN	80
>+
> #define CONNMGR_REQUEST_PORTAL	  1
> #define CONNMGR_REPLY_PORTAL	    2
> //#define OSC_REQUEST_PORTAL	    3
>diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h
>b/drivers/staging/lustre/lustre/include/lustre_fid.h
>index 2d6fbb4..0a0929f 100644
>--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
>+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
>@@ -358,7 +358,7 @@ struct lu_client_seq {
> 	 * Service uuid, passed from MDT + seq name to form unique seq name to
> 	 * use it with procfs.
> 	 */
>-	char		    lcs_name[80];
>+	char		    lcs_name[LUSTRE_MDT_MAXNAMELEN];
> 
> 	/*
> 	 * Sequence width, that is how many objects may be allocated in one
>@@ -408,7 +408,7 @@ struct lu_server_seq {
> 	 * Service uuid, passed from MDT + seq name to form unique seq name to
> 	 * use it with procfs.
> 	 */
>-	char		    lss_name[80];
>+	char		    lss_name[LUSTRE_MDT_MAXNAMELEN];
> 
> 	/*
> 	 * Allocation chunks for super and meta sequences. Default values are
>diff --git a/drivers/staging/lustre/lustre/include/lustre_fld.h
>b/drivers/staging/lustre/lustre/include/lustre_fld.h
>index 64c5048..5ee4b1e 100644
>--- a/drivers/staging/lustre/lustre/include/lustre_fld.h
>+++ b/drivers/staging/lustre/lustre/include/lustre_fld.h
>@@ -93,7 +93,7 @@ struct lu_server_fld {
> 
> 	/**
> 	 * Fld service name in form "fld-srv-lustre-MDTXXX" */
>-	char		     lsf_name[80];
>+	char		     lsf_name[LUSTRE_MDT_MAXNAMELEN];
> 
> };
> 
>@@ -124,7 +124,7 @@ struct lu_client_fld {
> 
> 	/**
> 	 * Client fld proc entry name. */
>-	char		     lcf_name[80];
>+	char		     lcf_name[LUSTRE_MDT_MAXNAMELEN];
> 
> 	int		      lcf_flags;
> };
>-- 
>2.1.1
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


