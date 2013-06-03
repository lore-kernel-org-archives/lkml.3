Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3FCC2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:28:53 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:56566
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab3FCC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:28:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -16
X-BigFish: VS-16(zzbb2dI98dI9371I936eI1432I4015Ia65Rzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51ABFF5F.4020409@freescale.com>
Date: Mon, 3 Jun 2013 10:28:47 +0800
From: Chen Yuanquan-B41889 <B41889@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net> <51A5CAC1.6030800@freescale.com> <20130531051423.GA15505@roeck-us.net> <1369979047.3928.112.camel@pasglop> <20130601135809.GA6395@roeck-us.net>
In-Reply-To: <20130601135809.GA6395@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2013 09:58 PM, Guenter Roeck wrote:
> On Fri, May 31, 2013 at 03:44:07PM +1000, Benjamin Herrenschmidt wrote:
>> On Thu, 2013-05-30 at 22:14 -0700, Guenter Roeck wrote:
>>> On Wed, May 29, 2013 at 05:30:41PM +0800, Chen Yuanquan-B41889 wrote:
>>>> On 05/29/2013 01:35 AM, Guenter Roeck wrote:
>>>>> bios_add_device(). Drop explicit calls to pcibios_setup_device();
>>>>> this makes pcibios_setup_bus_devices() a noop function which could
>>>>> eve
>>>> Yeah, it's more reasonable to do the irq and DMA related initialization
>>>> in one code path for all devices.
>>>>
>>> Any comments / feedback on the code itself ?
>> Sorry, I haven't had a chance to review it yet, I'm fairly bogged down
>> at the moment. I want to tread carefully because the previous iteration
>> of changing that stuff did break a few platforms in the end.
>>
> Hi Ben,
>
> the comment was actuially directed towards Yuanquan.
>
> No problem, take your time. I did my best to test it, but I agree that this is a
> critical area of the code, and it would be desirable to get additional scrutiny
> and test feedback.
>
> The code has been running in our system (P2020 and P5040) for several months.
> I was preparing a patch for upstream submission when I noticed commit 37f02195b.
> After testing ithis commit, I noticed the problems with it and wrote this patch,
> which aligns the code with our initial patch. I tested it as good as I could on
> our systems as well as with a P5040 evaluation board and an Intel GE PCIe
> card.
>
> Thanks,
> Guenter
>

Hi Guenter,

Your patch makes sure the initialization of DMA and irq in one code path 
and also
avoids the initialization called two times(in pci bus scanning and 
pci_enable_device()
in device driver) for no-hot-plugged pci device. It's much more reasonable!

I don't know why you also remove the function "set_dev_node()" ? As I 
know, the
function just be called here. I think it should remain in your new function
pcibios_add_device().

Regards,
Yuanquan

>


