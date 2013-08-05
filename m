Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3HESn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:43:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:36901 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3HESn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:43:27 -0400
Message-ID: <51FFF244.9000604@atmel.com>
Date: Mon, 5 Aug 2013 19:43:16 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new device.
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com> <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com> <20130805175302.GJ5051@mwanda>
In-Reply-To: <20130805175302.GJ5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 18:53, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 06:40:13PM +0100, Rupesh Gujare wrote:
>> This patch fixes crash issue when there is quick cycle of
>> de-enumeration & enumeration due to loss of wireless link.
>>
>> It is found that sometimes new device (or coming back device)
>> returns very fast, even before USB core read out hub status,
>> resulting in allocation of same port, which results in unstable
>> system & crash.
>>
>> Above issue is resolved by making sure that we always assign
>> new port to new device, making sure that USB core reads correct
>> hub status.
>>
> This feels like papering over the problem.  Surely the real fix
> would be to improve the reference counting.
>
> This patch is probably effective but it makes the code more subtle
> and it shows that we don't really understand what we are doing with
> regards to reference counting.
>
>

Probably this is easier way to fix issue, since we don't have reference 
count for ports & we rely on flags to check port status.
Any suggestions are appreciated.

-- 
Regards,
Rupesh Gujare

