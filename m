Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaI3G6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:58:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaI3G6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:58:20 -0400
Message-ID: <542A548A.7040308@nod.at>
Date: Tue, 30 Sep 2014 08:58:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
References: <1412029248-22454-1-git-send-email-richard@nod.at>	 <1412029248-22454-2-git-send-email-richard@nod.at> <1412058366.23429.77.camel@sauron.fi.intel.com>
In-Reply-To: <1412058366.23429.77.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.09.2014 08:26, schrieb Artem Bityutskiy:
> On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
>> ...otherwise the deferred work might run after datastructures
>> got freed and corrupt memory.
> 
> How can this happend? The background thread is stopped by this time
> already, so what are the other possibilities? And why is this
> fastmap-only?

This has nothing do to with the background thread.
Fastmap has a work queue. If one fastmap work has been
scheuled we have to wait for it.

Thanks,
//richard
