Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbbAPPzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:55:24 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45973 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbbAPPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:55:20 -0500
Message-ID: <54B93466.9010601@hurleysoftware.com>
Date: Fri, 16 Jan 2015 10:55:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Du <dudenis2000@yahoo.ca>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Christian Riesch <christian.riesch@omicron.at>
Subject: Re: [PATCH v2] n_tty: Fix unordered accesses to lockless read buffer
References: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1421113668-20468-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 08:47 PM, Peter Hurley wrote:
> Add commit_head buffer index, which the producer-side publishes
> after input processing in non-canon mode. This ensures the consumer-side
> observes correctly-ordered writes in non-canonical mode (ie., the buffer
> data is written before the buffer index is advanced). Fix consumer-side
> uses of read_cnt() to use commit_head instead.
> 
> Add required memory barriers to the tail index to guarantee
> the consumer-side has completed the loads before the producer-side
> begins writing new data. Open-code the producer-side receive_room()
> into the i/o loop.

Hi Greg,

Please don't apply this. I've been testing a v3 series that I should be
able to get to you today.

Regards,
Peter Hurley

