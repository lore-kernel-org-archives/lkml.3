Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab3DYN6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:58:10 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41041 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3DYN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <51780EDA.3000003@sgi.com>
References: <CAG82n_ni9ZAThGbMfqqObnz7QyQpH18G4hYBLt+BdeRHPE6EBg@mail.gmail.com>
 <CAErSpo5VaiuH+WT4RdM9yU9AHMkUKzATMiNzhixRU04_aZusBg@mail.gmail.com> <51780EDA.3000003@sgi.com>
From: Bian LuLu <helianthus.lu@gmail.com>
Date: Thu, 25 Apr 2013 21:57:44 +0800
Message-ID: <CAG82n_kBYQpCRDmY7ghivXY60hBMF_5HHZUAT1d-xWD9OZvdrg@mail.gmail.com>
Subject: Re: [RFC] The meaning of local_cpulist and local_cpus
To: Mike Travis <travis@sgi.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou .
But I still can not understand what is the meaning of cuplist.
my linux version is ubuntu 12.04, and
my system:/$ cat /sys/devices/pci0000:00/0000:00:1a.0/local_cpulist
 the result is '0-7',

I just don't konw what are they represent .Could  you give me more
detailed information about local_cpulist and local_cpus,and their
relations.
thanks in advance :)

On Thu, Apr 25, 2013 at 12:56 AM, Mike Travis <travis@sgi.com> wrote:
>
>
> On 4/24/2013 9:48 AM, Bjorn Helgaas wrote:
>> [+cc linux-pci, Mike]
>>
>> On Wed, Apr 24, 2013 at 4:06 AM, Bian LuLu <helianthus.lu@gmail.com> wrote:
>>> Hi all,
>>>
>>> Recently, i read some codes of PCI portions. I think
>>> local_cpulist is a list about one kind of CPU and
>>> local_cpus is a mask of CPU. But i am not sure when
>>> and how i should use these two parameters.
>>>
>>> See http://lxr.linux.no/linux+v3.5.4/drivers/pci/pci-sysfs.c#L390 for
>>> details.
>>>
>>> Would anyone please give me some suggestions?
>>> Thanks in advance ;-)
>>
>> I don't know off-hand, but maybe Mike or somebody on linux-pci does.
>> It looks like Mike added local_cpulist with 39106dcf85.
>>
>
> It primarily comes into play when you have a large # of cpus.
I can not understand the symbol of '#' ,what is the meaning of it?
> Here's the difference on a system that has 1024 cpu threads:
>
> harp31-sys:/sys/devices/system/node/node20 # cat cpulist
> 160-167,672-679
> harp31-sys:/sys/devices/system/node/node20 # cat cpumap
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,000000ff,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,00000000,00000000,
> 00000000,00000000,00000000,00000000,00000000,000000ff,00000000,
> 00000000,00000000,00000000,00000000
>
> Which is easier to interpret?  :)
>
> But there are some older user side utilities that still
> use the mask format.
