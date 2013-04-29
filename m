Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3D2L1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:27:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54930 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab3D2L1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:27:17 -0400
Message-ID: <517E5905.1070700@gmail.com>
Date: Mon, 29 Apr 2013 07:27:01 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: perf: report loops endlessly if record was killed via SIGTERM
References: <1367222415.4656.61.camel@marge.simpson.net>
In-Reply-To: <1367222415.4656.61.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/13 4:00 AM, Mike Galbraith wrote:
> Say SIGINT instead,
> and it works as expected.  SIGTERM leaves perf.data in a bad state that
> report can't deal with, but it'll happily keep trying forever.

header is usually updated on_exit which requires a clean exit. perhaps 
we should add SIGTERM to the signal list.

David
