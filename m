Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaFMNqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:46:48 -0400
Received: from smtp.pobox.com ([208.72.237.35]:54637 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaFMNqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=oBLLOJ
	vdXU7WpCZvXCoq7pX1hkrkSdcGefUpmY0v3nH7rBfjj8LUDhAAIyJ9AVQ3BwKHvx
	6mUwI2SY1Zy7q7ZiSI2bED0/dJx2CEqdZTocv2A8RVd8FT/eQxjLmlh3swU6HHre
	0L0YirQyywRzcZnA8e5Ew1zKzU5/Y5DKv/WAA=
Message-ID: <539B00BE.4080206@pobox.com>
Date: Fri, 13 Jun 2014 14:46:38 +0100
From: Brian Candler <b.candler@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: tap interface apparently rate-limited to 1 packet per 12ms
References: <53957C85.4040700@pobox.com>
In-Reply-To: <53957C85.4040700@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 25844C08-F301-11E3-A2E1-9903E9FBB39C-28021239!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW this turned out to be a silly mistake on my side. "ping -f" 
rate-limits its output when it's not receiving any reply packets. Using 
a small C program to send a burst of UDP packets, there's no delay.

It appears pretty much coincidental that the ~10ms packet processing 
interval in dynamips is similar to the 10ms delay for ping -f sending 
packets (MININTERVAL)

Sorry for the noise :-(

