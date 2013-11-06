Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab3KFLwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:52:50 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:53394 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3KFLwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:52:49 -0500
Message-ID: <527A2D8B.6030901@ladisch.de>
Date: Wed, 06 Nov 2013 12:52:43 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is __ffs64 supposed to be zero based?
References: <5279ECA8.5080701@candelatech.com>
In-Reply-To: <5279ECA8.5080701@candelatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> Similarly named methods elsewhere seem to indicate it is supposed to be
> ones-based counting (ie, bit (1<<0) would be considred 'bit 1'.

ffs() is defined to use one-based counting:
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/ffs.html>

__ffs() uses zero-based counting.  On gcc, it's likely to be implemented
with__builtin_ctz*(), whose documentation says:
| Returns the number of trailing 0-bits in x, starting at the least
| significant bit position.


Regards,
Clemens
