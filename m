Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbbAVTUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:20:45 -0500
Received: from box2.japko.eu ([91.121.152.53]:38516 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbbAVTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:20:44 -0500
Date: Thu, 22 Jan 2015 20:18:13 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Joe Perches <joe@perches.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgnc: fix long lines in PCI device table
Message-ID: <20150122191813.GB30234@box2.japko.eu>
References: <20150122185524.GA18274@box2.japko.eu>
 <1421953858.2702.5.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1421953858.2702.5.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:10:58AM -0800, Joe Perches wrote:
>On Thu, 2015-01-22 at 19:55 +0100, Krzysztof Adamski wrote:
>> This patch fixes coding style of PCI device table declaration.
>[]
>> diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
>[]
>> @@ -98,11 +98,11 @@ static struct timer_list dgnc_poll_timer;
>>
>>
>>  static struct pci_device_id dgnc_pci_tbl[] = {
>
>const
>
>> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	0 },
>> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	1 },
>> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	2 },
>> -	{	DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID, PCI_ANY_ID, PCI_ANY_ID, 0, 0,	3 },
>> -	{0,}						/* 0 terminated list. */
>> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID), .driver_data = 0},
>> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
>> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID), .driver_data = 2},
>> +	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},
>> +	{0,}
>
>Maybe better to keep the alignment of .driver_data
>
>+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_DID),     .driver_data = 0},
>+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_4_422_DID), .driver_data = 1},
>+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_DID),     .driver_data = 2},
>+	{PCI_DEVICE(DIGI_VID, PCI_DEVICE_CLASSIC_8_422_DID), .driver_data = 3},
>

Good idea, looks better this way, I'll resend.
