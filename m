Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3FFHCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:02:39 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:63514 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538Ab3FFHCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:02:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBAHcwsFGVhxBY/2dsb2JhbAANTIM5v0GBEoMXAQEBAwFOKgEFCwsOCgkWDwkDAgECAQ8QJgYIBQEFAgEBGQSHWgMJEqlsiVINiFKMUIJbB4NbA5VYgxCIcoIChnuBSQ
X-IronPort-AV: E=Sophos;i="4.87,813,1363104000"; 
   d="scan'208";a="342080266"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 342080266
X-WN-SMTPAUTHID: gregungerer
Message-ID: <51B03219.4020602@uclinux.org>
Date: Thu, 06 Jun 2013 16:54:17 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH v3, part1 07/10] PCI, unicore, m68k: remove redundant
 call of pci_bus_add_devices()
References: <1369489718-25869-1-git-send-email-jiang.liu@huawei.com> <1369489718-25869-8-git-send-email-jiang.liu@huawei.com> <CAErSpo7Lbu_MuxYGa6sghu7xuDJ9ZFN8pK0=xM0QMOwr=P2Y_Q@mail.gmail.com>
In-Reply-To: <CAErSpo7Lbu_MuxYGa6sghu7xuDJ9ZFN8pK0=xM0QMOwr=P2Y_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 06/06/13 07:31, Bjorn Helgaas wrote:
> [+cc m68k and unicore32 maintainers]
> 
> On Sat, May 25, 2013 at 7:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> pci_scan_bus() and pci_scan_root_bus() has called pci_bus_add_devices()
>> once, so remove the redundant call of pci_bus_add_devices().
>> On the other handle, subsys_init() callbacks will be invoked before
>> device_init() callbacks, so it should be safe to remove the redundant
>> calls.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  arch/m68k/platform/coldfire/pci.c | 2 +-
>>  arch/unicore32/kernel/pci.c       | 5 -----
>>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> m68k and unicore32 guys:
> 
> I plan to apply the patch below.  I actually split it into two, one
> for m68k and another for unicore32.  If you object or would rather
> push it through your trees, let me know.  I don't think the rest of
> the series has any actual dependency on this, so there shouldn't be
> any problem if you want to take it yourselves.

I have no objection for m68k, feel free to push it through your tree.
I can't test the change in a board that has a PCI card in it right at
the moment, but otherwise:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


> Bjorn
> 
>> diff --git a/arch/m68k/platform/coldfire/pci.c b/arch/m68k/platform/coldfire/pci.c
>> index 8572246..2345972 100644
>> --- a/arch/m68k/platform/coldfire/pci.c
>> +++ b/arch/m68k/platform/coldfire/pci.c
>> @@ -320,7 +320,7 @@ static int __init mcf_pci_init(void)
>>         pci_bus_size_bridges(rootbus);
>>         pci_bus_assign_resources(rootbus);
>>         pci_enable_bridges(rootbus);
>> -       pci_bus_add_devices(rootbus);
>> +
>>         return 0;
>>  }
>>
>> diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
>> index ef69c0c..374a055 100644
>> --- a/arch/unicore32/kernel/pci.c
>> +++ b/arch/unicore32/kernel/pci.c
>> @@ -277,11 +277,6 @@ static int __init pci_common_init(void)
>>                 pci_bus_assign_resources(puv3_bus);
>>         }
>>
>> -       /*
>> -        * Tell drivers about devices found.
>> -        */
>> -       pci_bus_add_devices(puv3_bus);
>> -
>>         return 0;
>>  }
>>  subsys_initcall(pci_common_init);
>> --
>> 1.8.1.2
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

