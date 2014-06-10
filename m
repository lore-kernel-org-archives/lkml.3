Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaFJNWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:22:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54343 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaFJNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:22:01 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-45-5397067654aa
Message-id: <53970660.4030101@samsung.com>
Date: Tue, 10 Jun 2014 16:21:36 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Boyer <jwboyer@redhat.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin keys
 only
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
 <cover.1402387862.git.d.kasatkin@samsung.com>
 <20140610122008.GA31944@hansolo.jdub.homelinux.org>
 <1402404750.5350.7.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402404750.5350.7.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xK7plbNODDd6csLZ41/SbxeLL0jqL
	A++esFjM3vWQxeLyrjlsFh96HrFZXH04m8Xi04pJzA4cHjtn3WX3mHZiGYvHg0ObWTze77vK
	5rHuxld2j8+b5ALYorhsUlJzMstSi/TtErgydk5cyVqwh7vix9M/LA2MSzm7GDk5JARMJFb0
	3WCHsMUkLtxbz9bFyMUhJLCUUaL/0XYop5FJYsKZ88wQzixGiUO7XzCDtPAKaEn8+fuUCcRm
	EVCVmNZ+iRHEZhPQk9jQ/ANoLAeHqECExOMLQhDlghI/Jt9jAbFFBLwkGibeBJvJLLCCUWLK
	kS9gvcICIRLHvs1nh1j2glFi8YwmsAWcAm4Sr/4uYQWxmQXUJSbNW8QMYctLbF7zFswWAjqi
	e+1aNoh/FCVOTz7HPIFReBaS5bOQtM9C0r6AkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4m
	RkgUfd3BuPSY1SFGAQ5GJR5eA/9pwUKsiWXFlbmHGCU4mJVEeNv+AoV4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwGpc5Hv75heOiq2pnw0cZZ51pfnear0y+MmFuSGmKlkigKZuPQc43lrPl3yaH
	z7+twnXyLidjUPE/7aUhpRpafXl3rmy2eLOEw7/RePe8J0uCu1fde3D66J3g2cWcsmnPJzQ6
	TTGqXXLi3DOZ6TcOi752CKswXXGJ/9e0w7kF8eq+LLf7nh9zV2Ipzkg01GIuKk4EAMyMmyWA	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/14 15:52, Mimi Zohar wrote:
> On Tue, 2014-06-10 at 08:20 -0400, Josh Boyer wrote: 
>> On Tue, Jun 10, 2014 at 11:48:14AM +0300, Dmitry Kasatkin wrote:
>>> Also I want to discuss here Fedora UEFI patches as they are the reason for
>>> the these original patchset.
>>>
>>> http://pkgs.fedoraproject.org/cgit/kernel.git/tree/modsign-uefi.patch
>>>
>>> They provide functionality to specify MokIgnoreDb variable to limit loading of
>>> UEFI keys only from MOK List, while ignoring DB. This is certainly a good
>>> functionality. But once MODULE_SIG_UEFI is enabled, it looks there is no way
>>> to prevent loading keys from UEFI at all. And this might not be a good default
>>> functionality. Someone might want not allow loading of keys from UEFI unless
>>> kernel parameter is specified to allow it without recompiling the kernel
>>> and disabling MODULE_SIG_UEFI.
>>>
>>> Josh, why such design decision was made?
>> IIRC, it's because kernel parameters can be added programmatically from a
>> remote user if they gain root access.  Having a kernel parameter to
>> disable a key piece of secure boot isn't all that great.  We disable
>> other kernel parameters like acpi_rspd as well.
> In this case, there shouldn't be a problem as the kernel parameters
> would further limit the keys usage.
>
> Mimi

Josh probably means that it can be removed and restriction is lifted..
And after reboot, all keys come to the keyring..


>

