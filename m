Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3IPSdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:33:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59020 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3IPSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:33:05 -0400
Date: Mon, 16 Sep 2013 11:33:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
Message-ID: <20130916183301.GB28553@roeck-us.net>
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net>
 <CAMuHMdWJ6w5WnY-80SQpYWiVkvaPNbU7w5-UAxqFxPfFVjB1+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWJ6w5WnY-80SQpYWiVkvaPNbU7w5-UAxqFxPfFVjB1+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 10:15:47AM +0200, Geert Uytterhoeven wrote:
> On Sun, Sep 15, 2013 at 6:39 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | $(modpost) -s -T -
> > +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | \
> > +       while read a; do [ -f $a ] && echo $a; done | $(modpost) -s -T -
> 
> I'm wondering whether this can be filtered without using a shell while loop?
> E.g. using "ls"?
> 
I sent another version using 'ls'. Using 'find' would be possible as well,
though both need an error redirect. Hope one of the versions is acceptable.

If anyone has a better idea, please let me know.

Thanks,
Guenter
