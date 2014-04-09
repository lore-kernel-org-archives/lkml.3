Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbaDIPg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:36:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38862 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIPg4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 11:36:56 -0400
Message-Id: <5345853502000078000074F8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 16:36:53 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@Citrix.com>, <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [XEN PATCH 1/2] hvm: Support more than 32 VCPUS when
 migrating.
References: <1396859560.22845.4.camel@kazak.uk.xensource.com>
 <1396977950-8789-1-git-send-email-konrad@kernel.org>
 <1396977950-8789-2-git-send-email-konrad@kernel.org>
 <534529A40200007800007055@nat28.tlf.novell.com>
 <20140409152706.GF5860@phenom.dumpdata.com>
In-Reply-To: <20140409152706.GF5860@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.04.14 at 17:27, <konrad.wilk@oracle.com> wrote:
> On Wed, Apr 09, 2014 at 10:06:12AM +0100, Jan Beulich wrote:
>> >>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote:
>> > --- a/xen/arch/x86/hvm/hvm.c
>> > +++ b/xen/arch/x86/hvm/hvm.c
>> > @@ -3470,6 +3470,9 @@ static long hvm_vcpu_op(
>> >      case VCPUOP_stop_singleshot_timer:
>> >      case VCPUOP_register_vcpu_info:
>> >      case VCPUOP_register_vcpu_time_memory_area:
>> > +    case VCPUOP_down:
>> > +    case VCPUOP_up:
>> > +    case VCPUOP_is_up:
>> 
>> This, if I checked it properly, leaves only VCPUOP_initialise,
>> VCPUOP_send_nmi, and VCPUOP_get_physid disallowed for HVM.
>> None of which look inherently bad to be used by HVM (but
>> VCPUOP_initialise certainly would need closer checking), so I
>> wonder whether either the wrapper shouldn't be dropped altogether
>> or at least be converted from a white list approach to a black list one.
> 
> I was being conservative here because I did not want to allow the
> other ones without at least testing it.
> 
> Perhaps that can be done as a seperate patch and this just as
> a bug-fix?

I'm clearly not in favor of the patch as is - minimally I'd want it to
convert the white list to a black list. And once you do this it would
seem rather natural to not pointlessly add entries.

Jan

