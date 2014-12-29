Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaL2Npv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:45:51 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36627 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaL2Npr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:45:47 -0500
Message-ID: <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christophe Fillot <cf@utc.fr>
Cc: linux-ima-user@lists.sourceforge.net, Rob Landley <rob@landley.net>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 29 Dec 2014 08:45:36 -0500
In-Reply-To: <5476EBAC.8090103@utc.fr>
References: <5463ABC8.10308@utc.fr>
	 <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <547617AF.6000604@utc.fr>
	 <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5476EBAC.8090103@utc.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122913-0029-0000-0000-000000E9320D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 10:15 +0100, Christophe Fillot wrote:
> >
> > Are you using an initrd not an initramfs?  According to
> > Documentation/filesystems/ramfs-rootfs-initramfs.txt, "If
> CONFIG_TMPFS
> > is enabled, rootfs will use tmpfs instead of ramfs by default".
> >
> Yes, that what I thought too, but it seems that it is not really the 
> case because of this test:
> 
>      if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
>          (!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
>          err = shmem_init();
>          is_tmpfs = true;
>      } else {
>          err = init_ramfs_fs();
>      }

[CC'ing Rob Landley, lsm, lkml]

Thanks!  "saved_root_name" is set to the boot command line "root="
option, which in my case is the UUID.  I'm not sure why real root should
impact the initramfs tmpfs/ramfs decision.

Unless there is a good explanation, did you want to post a patch to
remove the test?

Mimi



