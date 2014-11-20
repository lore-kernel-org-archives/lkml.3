Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaKTNtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:49:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:7106 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756062AbaKTNtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:49:10 -0500
Date: Thu, 20 Nov 2014 08:49:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Byungchul Park <byungchul.park@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v5 2/2] tracing: add additional marks to signal very
 large time
Message-ID: <20141120084900.10c8a2f5@gandalf.local.home>
In-Reply-To: <20141120063846.GD27177@byungchulpark-X58A-UD3R>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
	<1416442535-31188-3-git-send-email-byungchul.park@lge.com>
	<20141119200604.6b57266d@gandalf.local.home>
	<87ioiapft4.fsf@sejong.aot.lge.com>
	<20141120063846.GD27177@byungchulpark-X58A-UD3R>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 15:38:46 +0900
Byungchul Park <byungchul.park@lge.com> wrote:


> > I think it's impossible since it's always true that 'd >= 0'.
> > 
> 
> If someone won't define "MARK(0ULL, ' ')", then i think it can happen. :)
> 

Actually, remove the "MARK(0ULL, ' ')" and keep the return value as is.
But clean it up a little like this:

	return (i == size) ? ' ' : mark[i].sym;

Notice the space between "size)" and "?"

-- Steve
