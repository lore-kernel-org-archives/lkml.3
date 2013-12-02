Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3LBKna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:43:30 -0500
Received: from mail.southpole.se ([37.247.8.11]:50069 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3LBKn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:43:29 -0500
Message-ID: <529C6495.3020305@southpole.se>
Date: Mon, 02 Dec 2013 11:44:37 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jingoo Han <jg1.han@samsung.com>, "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>  <20131128040750.GA29917@kroah.com>  <006001ceebfa$c85a1020$590e3060$%han@samsung.com>  <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>  <1385619863.12210.14.camel@joe-AO722> <529C026E.2000302@roeck-us.net>  <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>  <529C04C7.9050506@roeck-us.net>  <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com> <1385963295.2680.2.camel@joe-AO722>
In-Reply-To: <1385963295.2680.2.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 80999-13433
X-Assp-Session: 7FDDB5851528 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 12/02/2013 06:48 AM, Joe Perches wrote:
> (Adding Jonas Bonn to list as he added the macro in the first place...)

Thanks... ;)

Actually, I think I submitted an even uglier macro called 
DECLARE_PCI_DEVICE_TABLE... might have been the first kernel patch I 
ever sent?  In any case, it should certainly have been kindly rejected. 
  After it hit mainline Andrew Morton just about choked on his tea and 
renamed it DEFINE_PCI_DEVICE_TABLE.

>
> On Mon, 2013-12-02 at 13:03 +0900, Jingoo Han wrote:
>> On Monday, December 02, 2013 12:56 PM, Guenter Roeck wrote:
>>> On 12/01/2013 07:50 PM, Jingoo Han wrote:
>>>> On Monday, December 02, 2013 12:46 PM, Guenter Roeck wrote:
>>>>> On 12/01/2013 04:07 PM, Jingoo Han wrote:
>>>>>> On Friday, November 29, 2013 10:34 AM, Jingoo Han wrote:
>>>>>>> On Thursday, November 28, 2013 3:24 PM, Joe Perches wrote:
>>>>>>>> On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
>>>>>>>>> On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
>>>>>>>>>> On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
>>>>>>>>>>> On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
>>>>>>>>>>>> On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
>>>>>>>>>>>>> This macro is used to create a struct pci_device_id array.
>>>>>>>>>>>>
>>>>>>>>>>>> Yeah, and it's a horrid macro that deserves to be removed, please don't
>>>>>>>>>>>> use it in more places.
>>>>>>>>>>>>
>>>>>>>>>>>> Actually, if you could just remove it, that would be best, sorry, I'm
>>>>>>>>>>>> not going to take these patches.
>>>>>>>>>>>

Feel free to just remove the macro; it serves no purpose but to confuse. 
  That said, the underlying issue that the macro was supposed to resolve 
(if I recall correctly) was to make sure that all the struct 
pci_device_id instances were marked as const, as per the PCI 
documentation; if there's something checkpatch should be warning for 
it's simply that the struct is const.

/Jonas

