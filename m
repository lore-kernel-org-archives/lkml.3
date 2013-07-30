Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3G3O1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:27:11 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32733 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3G3O1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:27:09 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-49-51f7cd3c7396
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-topic: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-index: AQHOjRXfJ/5nZZSBIEm/1iKXnTSuJw==
Date: Tue, 30 Jul 2013 14:27:06 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174E4A6@sisaex01sj>
References: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
 <20130730142209.GA28956@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+wr67N2e+BBgv/cFr8nXSM3aJ58Xo2
	i/O3PjNbXN41h83iQ0+dA6vH71+TGD0W73nJ5LF/7hp2j0mHPzN5fN4kF8AaxWWTkpqTWZZa
	pG+XwJVxfsIXloI/nBWPL5xnbmCcyNHFyMkhIWAi0fHnAzOELSZx4d56ti5GLg4hgWWMEtvX
	HmWHcHqZJN7evMkI4cxnlNjVdooVpIVNQF3i8+sd7CC2iICGxMujt1hAipgFHjNKHG7byQiS
	EBZwlLhz7iIzRJGTxP5ZV5kgbD2JN3MmgdWwCKhKXHtyGqyGV8BeYsKEzWC2kECOxKSjd9lA
	bEag+76fWgPWyywgLtHcepMF4m4BiSV7zkP9ICrx8vE/oOM4gGxFie2rrSDKtSTW7zwO1aot
	8eTdBVaIVYISPybfY5nAKDYLydRZSFpmIWmZhaRlASPLKkax0uLkguKk9NQKQ73ixNzi0rx0
	veT83E2MkOir2sF456vNIUYBDkYlHt4NBd8ChVgTy4orcw8xSnAwK4nwnp/4PVCINyWxsiq1
	KD++qDQntfgQIxMHp1QDY6lWQ5ix1Kc3kS6uxzZMqlv4gNuy4tzH5sxCjpdK97LXK6obf67M
	b/my9Wfem1/dOZWT7x/Kn9G7bnbqloqr8wU2beFSu+wfkbKx1p97v6X7jV0VifzhxZMYvs2+
	ycgZXbV8dlyyxU3faY3m8YozTY9Es23NWRA1M0HFK9r9RtHrxncGL81ylViKMxINtZiLihMB
	r8OqAJwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 08:21 AM, Greg KH wrote:
> On Tue, Jul 30, 2013 at 02:11:51PM +0300, Tomas Winkler wrote:
>> Both H_IS and H_IE needs to be set to receive H_RDY
>> interrupt
>>
>> 1. Assert H_IS to clear the interrupts during hw reset
>> and use mei_me_reg_write instead of mei_hcsr_set as the later
>> strips down the H_IS
>>
>> 2. fix interrupt disablement embarrassing typo
>>    hcsr |= ~H_IE -> hcsr &= ~H_IE;
>> this will remove the unwanted interrupt on power down
>>
>> 3. remove useless debug print outs
>>
>> Cc: Shuah Khan <shuah.kh@samsung.com>
>> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>
>> V2: Fixed typo in Shuah email
>>
>> Hope this finally resolve the ME reset issue for all
>
> Can I get a "Tested-by:" from someone to ensure that it really does
> solve the problem?
>
> thanks,
>
> greg k-h
>

I will test it on my system and let you know.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
