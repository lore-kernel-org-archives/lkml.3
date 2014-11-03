Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaKCSWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:22:12 -0500
Received: from mout.gmx.net ([212.227.17.20]:55985 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaKCSWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:22:06 -0500
Message-ID: <5457C7B7.7050302@gmx.de>
Date: Mon, 03 Nov 2014 19:21:43 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>,
        "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net> <loom.20141021T140216-28@post.gmane.org> <20141027092311.GA9807@amd> <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com> <20141031093618.GB30321@quack.suse.cz>
In-Reply-To: <20141031093618.GB30321@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QWshZTAKkyo8PT9YnzIfYSyCdq325Mv+RLYzFl8ju3iLMWlnIzr
 vkIqDkGxx2Jje3M3ilSUYF0Vhi/Vg/u3lHTBmhaChQdwfMtazTC9k/bCMPKPmnyw3btVYnD
 6z2Ddo7crPhZ/lfAuRK4UWLhbdUrp4HxOTDD5zXgUHyvxPh3536Wws8WRTqUQbPYEfN/jqw
 9vA8Ns5ukykBEjfqXJMEg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.10.2014 10:36, Jan Kara wrote:
> On Mon 27-10-14 20:02:51, Sergey "Shnatsel" Davidoff wrote:
>>> If "recursive mtime" was available, would that work for you?
>>
>> It would work for detecting "offline" changes. I suppose recursive
>> mtime not viable for online monitoring, mostly because detecting file
>> renaming would be a massive PITA (and we already have fanotify with
>> exactly this problem).
>    Yes, you'll get only "something has changed in a subtree" information for
> each directory. You'd then have to rescan the directory to find out what
> has changed. But there's no simple solution for this - either you have to
> process tons of events for busy directory tree or you have to somehow
> reduce the amount of information provided to userspace...

If inotify_add_watch() would allow to mark a complete mount (like 
fanotify_mark() called with FAN_MOUNT) events for all files on this 
mount could be detected. If furthermore inotify_read() would return the 
complete relative path of the changed file relative to the mount in 
inotify_event->name, it would be obvious what the meaning of the event is.

Best regards

Heinrich Schuchardt

