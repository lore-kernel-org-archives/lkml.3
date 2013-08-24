Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3HXMt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 08:49:29 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:40797 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189Ab3HXMt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 08:49:28 -0400
Message-ID: <5218ABD5.1000400@hurleysoftware.com>
Date: Sat, 24 Aug 2013 08:49:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?U3Zlbm5pbmcgU8O4cmVuc2Vu?= <sss@secomea.dk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPC: bugfix for msgrcv with msgtyp < 0
References: <52189CB1.9030806@secomea.dk>
In-Reply-To: <52189CB1.9030806@secomea.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2013 07:44 AM, Svenning Sørensen wrote:
> According to 'man msgrcv':
> "If msgtyp is less than 0, the first message of the lowest type that is less
> than or equal to the absolute value of msgtyp shall be received."
>
> Bug: The kernel only returns a message if its type is 1; other messages with
> type < abs(msgtype) will never get returned.
>
> Fix: After having traversed the list to find the first message with the
> lowest type, we need to actually return that message.

Sorry for the breakage. Needs to go to -stable as well.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>


