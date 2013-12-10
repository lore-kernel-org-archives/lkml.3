Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3LJL0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:26:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab3LJL0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:26:08 -0500
Date: Tue, 10 Dec 2013 12:26:04 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131210112604.GQ22878@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
 <20131120183900.GA25735@localhost>
 <529D2BA6.5020005@linaro.org>
 <529D5805.20903@linaro.org>
 <20131206142602.GH22878@localhost>
 <52A27D51.1040805@linaro.org>
 <20131210102051.GO22878@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210102051.GO22878@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:20:51AM +0100, Miroslav Lichvar wrote:
> What does the following line from your patch mean?
> 
>         tick_error -= tk->xtime_interval;

Ok, I think I understand how it should work. There are two loops, the
bigadjust one is correcting only for ntp tick length and the other for
the cumulative error. I think it might work better if they were both
active at the same time instead of switching between them according to
the current ntp error.

-- 
Miroslav Lichvar
