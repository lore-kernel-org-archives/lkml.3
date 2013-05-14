Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3ENQPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:15:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54110 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3ENQO7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 14 May 2013 12:14:59 -0400
Message-Id: <51927F2002000078000D6224@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 14 May 2013 17:14:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "John Stultz" <john.stultz@linaro.org>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: sync the CMOS RTC as well
 as the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
 <1368467768-2316-4-git-send-email-david.vrabel@citrix.com>
 <51918ABB.5030501@linaro.org>
 <51920A9502000078000D5D84@nat28.tlf.novell.com>
 <51925F70.5000309@linaro.org>
In-Reply-To: <51925F70.5000309@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.05.13 at 17:59, John Stultz <john.stultz@linaro.org> wrote:
> On 05/14/2013 12:57 AM, Jan Beulich wrote:
>>>>> On 14.05.13 at 02:52, John Stultz <john.stultz@linaro.org> wrote:
>>> Honestly, it seems a little strange to me. If you're running as dom0,
>>> why does HYPERVISOR_dom0_op() not cause the hypervisor to set the cmos
>>> its virtualizing? This seems to mess with the proper virtualization
>>> layering.
>> Thy hypervisor tries to control as little system and peripheral devices
>> as possible, and the CMOS (including the clock) is among those not
>> controlled by it, but by Dom0.
> 
> Huh. So what does calling HYPERVISOR_dom0_op do then?

Here it merely tells the hypervisor that the wall clock changed (so
it can propagate this on to DomU-s).

Jan

