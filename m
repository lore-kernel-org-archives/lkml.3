Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3FDINh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:13:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41987 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3FDINe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:11:2>);
	Tue, 4 Jun 2013 04:13:34 -0400
Message-Id: <51ADBDC402000078000DAF36@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 04 Jun 2013 09:13:24 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "liguang" <lig.fnst@cn.fujitsu.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Len Brown" <lenb@kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Liu Jinsong" <jinsong.liu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen: remove bm_rld_set of xen_processor_flags
References: <1370333128-11412-1-git-send-email-lig.fnst@cn.fujitsu.com>
 <1370333128-11412-2-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1370333128-11412-2-git-send-email-lig.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.06.13 at 10:05, liguang <lig.fnst@cn.fujitsu.com> wrote:
> bm_rld_set seems obsolete now
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  include/xen/interface/platform.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xen/interface/platform.h 
> b/include/xen/interface/platform.h
> index c57d5f6..7ffff33 100644
> --- a/include/xen/interface/platform.h
> +++ b/include/xen/interface/platform.h
> @@ -240,7 +240,6 @@ struct xen_processor_flags {
>  	uint32_t bm_check:1;
>  	uint32_t has_cst:1;
>  	uint32_t power_setup_done:1;
> -	uint32_t bm_rld_set:1;
>  };
>  
>  struct xen_processor_power {

Any such patch would need to be submitted against the master copy
of the header (in the Xen repo), and by recognizing that you'd also
notice that this is part of a public ABI, and hence can't be removed,
but at best can be documented as obsolete. Of course you'd first
need to check whether the hypervisor makes any use of that bit
when passed down from Dom0.

Jan

