Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3IOPGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:06:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59677 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3IOPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:06:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5235CCD8.4080304@roeck-us.net>
Date: Sun, 15 Sep 2013 08:06:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net> <CAMuHMdWJ6w5WnY-80SQpYWiVkvaPNbU7w5-UAxqFxPfFVjB1+w@mail.gmail.com>
In-Reply-To: <CAMuHMdWJ6w5WnY-80SQpYWiVkvaPNbU7w5-UAxqFxPfFVjB1+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 01:15 AM, Geert Uytterhoeven wrote:
> On Sun, Sep 15, 2013 at 6:39 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | $(modpost) -s -T -
>> +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | \
>> +       while read a; do [ -f $a ] && echo $a; done | $(modpost) -s -T -
>
> I'm wondering whether this can be filtered without using a shell while loop?
> E.g. using "ls"?
>

An alternative would be "$(MODLISTCMD) | sed 's/\.ko$/.o/' | xargs -r ls 2>/dev/null | ..."

I was a bit concerned about side effects of unexpected ls output.
But I'll be happy to change it along that line if people think
that it is better (and/or less ugly).

Guenter

