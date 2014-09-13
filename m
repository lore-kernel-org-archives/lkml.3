Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaIMQSD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:18:03 -0400
Received: from mout.gmx.net ([212.227.15.19]:52393 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaIMQSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:18:00 -0400
Message-ID: <54146D8D.9090708@gmx.de>
Date: Sat, 13 Sep 2014 18:15:09 +0200
From: Heinrich Schuchardt <xypron.debian@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andrew Vagin <avagin@parallels.com>, Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
References: <1410177716-3965-1-git-send-email-avagin@openvz.org> <20140909012712.GV7996@ZenIV.linux.org.uk> <20140909085439.GB25034@quack.suse.cz> <20140910094318.GA19472@paralelels.com>
In-Reply-To: <20140910094318.GA19472@paralelels.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:o6gl1GMJnGNnWbA1teBreot8a1sia/eHZ7vmrqtTlw/oDyv90ak
 UxLa1oji2eGb2G8seN9Ki1achLnQ4w1wR8kK4SCUiWbPiggVLPzKMJJKziM4DYOTCJ+K8Sh
 FmYsVcdNYACqPxBKdV6t2alNsAbtHlUR+E67C2NaW83ZFsxZmlHTbAKr1m9Z/HZ+rjoNMmR
 EacA9087kEZjtPBl3CqwQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-09-14 02:27:12, Al Viro wrote:
http://lkml.org/lkml/2014/9/8/762
 > I agree that it changes user-visible ABI and I agree the behavior
 > isn't really specified in the manpage.

Shouldn't we start with putting the expected behavior into the manpage 
before patching the code? I am missing a patch for man7/inotify.7.

On Mon, Sep 08, 2014 at 04:01:56PM +0400, Andrey Vagin wrote:
http://lkml.org/lkml/2014/9/8/219
 >
 > 	fd = inotify_init1(IN_NONBLOCK);
 > 	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
 > 	link(path, path_link);
 >
 > 	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
 >
 > 	unlink(path);
 > 	unlink(path_link);
 >
 > 	printf(" --- unlink\n");
 > 	read_evetns(fd);
 >
 > 	close(deleted);
 > 	printf(" --- close\n");
 > 	read_evetns(fd);
 >
 > Without this patch:
 >   --- unlink
 > 4	(IN_ATTRIB)
 > 400	(IN_DELETE_SELF)
 > 8000	(IN_IGNORED)
 >   --- close
 > FAIL
 >
 > With this patch:
 >   --- unlink
 > 4	(IN_ATTRIB)
 > 400	(IN_DELETE_SELF)
 >   --- close
 > 8	(IN_CLOSE_WRITE)
 > 400	(IN_DELETE_SELF)
 > 8000	(IN_IGNORED)
 > PASS

Shouldn't the second IN_DELETE_SELF occur before
--- close ?
Why is IN_CLOSE_WRITE created?

Best regards

Heinrich Schuchardt

