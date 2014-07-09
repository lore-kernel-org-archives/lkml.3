Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaGISYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:24:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39662 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbaGISYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:24:21 -0400
X-Sasl-enc: oF/9EMvE/iiMBZZe/uPW5IYPkbwKZzLJj76Zv5fo8rcM 1404930259
Message-ID: <53BD88C5.90606@fastmail.fm>
Date: Wed, 09 Jul 2014 19:24:05 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: gdm72xx: move T_CAPABILITY definitions to
 hci.h
References: <1404219616-1788-3-git-send-email-mpappas@fastmail.fm> <1404296287-3970-1-git-send-email-mpappas@fastmail.fm> <20140709102603.GV25880@mwanda>
In-Reply-To: <20140709102603.GV25880@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 11:26 AM, Dan Carpenter wrote:
>>  	/* GetInformation mac address */
>>  	len = 0;
>> @@ -621,12 +618,12 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
>>  	hci->length = H2B(len);
>>  	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
>>  
>> -	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
>> +	val = (1 << T_CAPABILITY_WIMAX) | (1 << T_CAPABILITY_MULTI_CS);
> 
> Double shifting here...  It should just be:
> 
> 	val = T_CAPABILITY_WIMAX | T_CAPABILITY_MULTI_CS;
> 

Ooops! Thanks for spotting that, will submit a corrected patch.

M.
