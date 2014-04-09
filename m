Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaDIJGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:06:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58672 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351AbaDIJGO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 05:06:14 -0400
Message-Id: <534529A40200007800007055@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 10:06:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <konrad@kernel.org>
Cc: <david.vrabel@Citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
In-Reply-To: <1396977950-8789-2-git-send-email-konrad@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote:
> --- a/xen/arch/x86/hvm/hvm.c
> +++ b/xen/arch/x86/hvm/hvm.c
> @@ -3470,6 +3470,9 @@ static long hvm_vcpu_op(
>      case VCPUOP_stop_singleshot_timer:
>      case VCPUOP_register_vcpu_info:
>      case VCPUOP_register_vcpu_time_memory_area:
> +    case VCPUOP_down:
> +    case VCPUOP_up:
> +    case VCPUOP_is_up:

This, if I checked it properly, leaves only VCPUOP_initialise,
VCPUOP_send_nmi, and VCPUOP_get_physid disallowed for HVM.
None of which look inherently bad to be used by HVM (but
VCPUOP_initialise certainly would need closer checking), so I
wonder whether either the wrapper shouldn't be dropped altogether
or at least be converted from a white list approach to a black list one.

Jan

