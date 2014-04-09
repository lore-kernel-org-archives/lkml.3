Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbaDIP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:27:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaDIP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:27:19 -0400
Date: Wed, 9 Apr 2014 11:27:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: konrad@kernel.org, david.vrabel@Citrix.com, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when migrating.
Message-ID: <20140409152706.GF5860@phenom.dumpdata.com>
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
 <534529A40200007800007055@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534529A40200007800007055@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:06:12AM +0100, Jan Beulich wrote:
> >>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote:
> > --- a/xen/arch/x86/hvm/hvm.c
> > +++ b/xen/arch/x86/hvm/hvm.c
> > @@ -3470,6 +3470,9 @@ static long hvm_vcpu_op(
> >      case VCPUOP_stop_singleshot_timer:
> >      case VCPUOP_register_vcpu_info:
> >      case VCPUOP_register_vcpu_time_memory_area:
> > +    case VCPUOP_down:
> > +    case VCPUOP_up:
> > +    case VCPUOP_is_up:
> 
> This, if I checked it properly, leaves only VCPUOP_initialise,
> VCPUOP_send_nmi, and VCPUOP_get_physid disallowed for HVM.
> None of which look inherently bad to be used by HVM (but
> VCPUOP_initialise certainly would need closer checking), so I
> wonder whether either the wrapper shouldn't be dropped altogether
> or at least be converted from a white list approach to a black list one.

I was being conservative here because I did not want to allow the
other ones without at least testing it.

Perhaps that can be done as a seperate patch and this just as
a bug-fix?

> 
> Jan
> 
