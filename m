Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaLKFMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:12:46 -0500
Received: from [133.145.228.5] ([133.145.228.5]:37424 "EHLO
	mail4.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLKFMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:12:45 -0500
Message-ID: <548927B1.2010502@hitachi.com>
Date: Thu, 11 Dec 2014 14:12:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au> <CAM9d7cgY6t7_XB+SryQft_BA0zbtcKN1ZrfQ-qONtb-SkB89Jw@mail.gmail.com>
In-Reply-To: <CAM9d7cgY6t7_XB+SryQft_BA0zbtcKN1ZrfQ-qONtb-SkB89Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2014/12/10 17:19), Namhyung Kim wrote:
> Hi Michael,
> 
> On Wed, Dec 10, 2014 at 1:38 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> usleep is a Fedoraism, it's not generally available on Debian based
>> systems AFAICS.
>>
>> GNU sleep accepts a floating point argument, so use that instead.
> 
> I tested it on busybox not Debian, sorry.  But it seems busybox's
> sleep doesn't support floating point argument..
> 
>   / # ls -l `which sleep`
>   lrwxrwxrwx     1  root     rooot       7 May 22  2014  /bin/sleep -> busybox
> 
>   / # sleep 0.1
>   sleep: invalid number '0.1'

I also have same result. Basically, ftracetest should be able to run on busybox.
So, I think we'd better check whether usleep is available, and if not, fallback
to sleep like as below.

  if which usleep &> /dev/null; then
    usleep 1
  else
    sleep 0.000001
  fi

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


