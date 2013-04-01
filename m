Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3DASUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:20:18 -0400
Received: from mx12.netapp.com ([216.240.18.77]:30726 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab3DASUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:20:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,387,1363158000"; 
   d="scan'208";a="36005897"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] nfsd4: do not export "u64" to userspace
Thread-Topic: [PATCH 6/8] nfsd4: do not export "u64" to userspace
Thread-Index: AQHOLwMAnhsmpPPzKUWIsgTmCPfda5jCImsA
Date: Mon, 1 Apr 2013 18:20:13 +0000
Message-ID: <1364840412.8165.5.camel@leira.trondhjem.org>
References: <1364839315.21627.69.camel@x61.thuisdomein>
In-Reply-To: <1364839315.21627.69.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.114]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <AF3C271A330F6441A8B314591EF724F0@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 20:01 +0200, Paul Bolle wrote:
> nfs4.h exports "u64" to userspace. Use "__u64" instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with a kernel build.
> 
> 1) I'm guessing userspace doesn't actually use NFS4_MAX_UINT64.
> 
>  include/uapi/linux/nfs4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/nfs4.h b/include/uapi/linux/nfs4.h
> index 788128e..35f5f4c 100644
> --- a/include/uapi/linux/nfs4.h
> +++ b/include/uapi/linux/nfs4.h
> @@ -150,7 +150,7 @@
>  #define NFS4_SECINFO_STYLE4_CURRENT_FH	0
>  #define NFS4_SECINFO_STYLE4_PARENT	1
>  
> -#define NFS4_MAX_UINT64	(~(u64)0)
> +#define NFS4_MAX_UINT64	(~(__u64)0)
>  
>  /* An NFS4 sessions server must support at least NFS4_MAX_OPS operations.
>   * If a compound requires more operations, adjust NFS4_MAX_OPS accordingly.

Please just move it into include/linux/nfs4.h. As you said above, there
is no reason to export this to userland at all.

Thanks
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
