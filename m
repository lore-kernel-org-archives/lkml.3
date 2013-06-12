Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3FLUxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:53:10 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:35780 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3FLUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:53:09 -0400
Message-ID: <51B8DFAD.30103@linux.vnet.ibm.com>
Date: Wed, 12 Jun 2013 17:53:01 -0300
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [ 00/79] 3.9.6-stable review
References: <20130611195312.352656079@linuxfoundation.org> <20130612202915.GA27379@roeck-us.net> <20130612203437.GA16588@roeck-us.net>
In-Reply-To: <20130612203437.GA16588@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061220-1524-0000-0000-00000668E863
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 05:34 PM, Guenter Roeck wrote:
> On Wed, Jun 12, 2013 at 01:29:15PM -0700, Guenter Roeck wrote:
>> On Tue, Jun 11, 2013 at 01:02:26PM -0700, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.9.6 release.
>>> There are 79 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu Jun 13 19:50:17 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.6-rc1.gz
>>> and the diffstat can be found below.
>>>
>> powerpc defconfig and as well as various other powerpc builds fail with:
>>
>> arch/powerpc/platforms/pseries/msi.c: In function 'rtas_hack_32bit_msi_gen2':
>> arch/powerpc/platforms/pseries/msi.c:408:34: error: 'struct pci_dev' has no member named 'msi_cap'
>> arch/powerpc/platforms/pseries/msi.c:410:35: error: 'struct pci_dev' has no member named 'msi_cap'
>> arch/powerpc/platforms/pseries/msi.c:411:35: error: 'struct pci_dev' has no member named 'msi_cap'
>>
>> Introduced by commit 7b58b0edaa2 (powerpc/pseries: Make 32-bit MSI quirk work
>> on systems lacking firmware support).
>>
> s/7b58b0edaa2/f1dd153121/
>
> 7b58b0edaa2 is from my git branch and won't help much.
>
> Guenter
>

Guenter,

The original patch that introduced these changes (commit f1dd153121 - 
powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmware 
support) depends on commit e375b561 (PCI: Cache MSI/MSI-X capability 
offsets in struct pci_dev), however, the patch I sent to the stable 
mailing-list were backported to be applied over 3.9.y. I have already 
sent an email to Greg to let him know that the original patch breaks the 
ppc build and the backported version should be picked up instead.


Thanks,

-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

