Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3JIK2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3JIK2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:28:14 -0400
Message-ID: <52552FBA.7040806@suse.cz>
Date: Wed, 09 Oct 2013 12:28:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Robert Richter <rric@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
References: <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com> <20130711135445.GA21500@sepie.suse.cz> <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com> <20130712105721.GF8731@rric.localhost> <20130717160506.GI8731@rric.localhost> <CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com> <20130717165743.GK8731@rric.localhost> <CA+55aFzhmV7iq+Pv37trMCmdNzk53ORAoj0a6rV14fzKta3Dhw@mail.gmail.com> <51E7B3D0.4060609@suse.cz> <20130930084945.GA1963@rric.localhost> <20130930163139.GA12450@free.fr> <CAMuHMdW-YWGgZjR9ow6FMW7BrOorbbVAEm9sYsVvPkfg-_=jag@mail.gmail.com>
In-Reply-To: <CAMuHMdW-YWGgZjR9ow6FMW7BrOorbbVAEm9sYsVvPkfg-_=jag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.10.2013 09:18, Geert Uytterhoeven wrote:
> On Mon, Sep 30, 2013 at 6:31 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
>> On 2013-09-30 10:49 +0200, Robert Richter spake thusly:
>>> On 18.07.13 11:22:24, Michal Marek wrote:
>>>>> So Michal (or ARM people - whoever wants to take the patch), just take
>>>>> my ack. No objections.
>>>>
>>>> I can add it to the kbuild tree if needed. Otherwise you can add
>>>> Acked-by: Michal Marek <mmarek@suse.cz>.
>>>
>>> This didn't make it upstream yet, can somebody at it to a tree?
>>
>> Since it's been acked-by Linus, I'll queue it in my tree, for Michal to
>> pull from. Expect a pull-request soon.
> 
> Sorry for chiming in that late, but I didn't think of this when reading the
> original submission.
> 
> Just doing "make oldconfig; make install" used to work.

On ARM and maybe other architectures.


> Removing the dependency of "make vmlinux" on vmlinux breaks this, doesn't it?

Yes.


> I had the habit of doing the above many years ago, when I was mostly doing
> native builds, and before I had my own custom linux-install-kernel
> script that e.g.
> knows how to copy kernels and modules around to NFS servers.
> 
> Not that I'm strongly attached to it, but there may be other users...

We can't eat the cake and have it :). What can be done is to make
arch/arm/boot/install.sh print a friendlier error message, like the x86
version does:

if [ ! -f "$1" ]; then
	echo ""                                                   1>&2
	echo " *** Missing file: $1"                              1>&2
	echo ' *** You need to run "make" before "make install".' 1>&2
	echo ""                                                   1>&2
	exit 1
fi

Michal
