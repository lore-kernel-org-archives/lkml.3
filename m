Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaG1Jyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:54:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62883 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaG1Jyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:54:46 -0400
Date: Mon, 28 Jul 2014 11:54:42 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
Message-ID: <20140728095442.GA4875@fancy-poultry.org>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
 <20140727083758.GA4834@fancy-poultry.org>
 <CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
X-Mailer: Mew version 6.6 on Emacs 24.3.1 / Mule 6.0 (HANACHIRUSATO)
X-Provags-ID: V02:K0:Op0FrJb59FjWm5pQhutc/n3rm3wLSkJExlcICQhO7Fs
 9PoI797BsDQmYp71rDYQpFIX27/SJR6lfcQ94bN4t+zf529geP
 KJsuGDhonk6svg0yLwNhRBUxMTkzBnH46kQ0vnHLISjgTqpUxR
 Sisc7J2w73kms6Jgxpt5TNybSQc66sPuHc4HAuQu0EM2q17UYz
 0FR+9kSOaoMHhoqvKlXrHKWDoHVl1BL7qYy9azintGIOn1EFH/
 SshgX82WBpNFWPC1gCVCXNM1NsvKunP7wmKA2ArkfmEy9KLgII
 F3/duMpmVFUGf/PmwYQIa8garKLv0vv8mkGg8Z5DtqfPYbanuk
 bkT9DUCFf2gzRhluwv0x8KA3ap0bNF9ZXP+tm0q0j
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First: my email you are quoting here was sent to you directly, off-list,
because it only contains common stuff and has nothing to do with
kernel development. In other words to avoid annoying lkml people. 
In addition, I placed an "Reply-to" header pointing back to me. 
Despite, you *manually* redirected your answer to my private mail 
back to the list, thus annoying people and breaking the informational
flow of this thread.


On 27.07.2014, Nick Krause wrote: 

> I am transferring into the same directory for the music 
> I am listening to.

So you produce a lot of disk I/O by writing/reading from the same disk
at the same time, and as you encounter stalls, you take this for a
kernel bug (which clearly is not). These stalls are most probably
caused by fsync() flushing your data/buffers, which is blocking.

So moving the music data you are listening to to another disk would
make things a lot easier.

> In addition , my cpu usage when doing this is half of my older

DMA transfer is mostly done be the controller itself, and not the CPU.

Btw, EOT for me.

