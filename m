Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3EMQpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:45:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34135 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3EMQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:45:43 -0400
X-Sasl-enc: BJb6NcJK5rEmVancD1RSEdBGiuJazOZWM3MFebY0KmLK 1368463542
Subject: Re: [RFC] teach argv_split() to ignore the spaces surrounded by \e
From: Colin Walters <walters@verbum.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Denys Vlasenko <vda.linux@googlemail.com>
In-Reply-To: <20130513143537.GA3278@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
	 <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
	 <20130510125826.GA553@redhat.com>
	 <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com>
	 <20130510153638.GA8179@redhat.com>
	 <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
	 <20130510171054.GA27479@redhat.com>
	 <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com>
	 <20130513141633.GB1613@redhat.com>  <20130513143537.GA3278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 May 2013 12:06:07 -0400
Message-ID: <1368461167.11935.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 16:35 +0200, Oleg Nesterov wrote:

> Yes, we can change format_corename() to construct "argv" by hand, and
> this was my iniital plan. But perhaps it would be better to not uglify
> this code even more?

Sure this \e is less code, but it seems pretty ugly to me.  Maybe a way
to keep fs/coredump.c sane would be always constructing an argv, and
then in the !ispipe case just join them into one string.

Though I'm still inclined to change systemd to read /proc/pid/cmdline
like abrt does; that way it works on current kernels too.

For what it's worth I noticed this problem with dconf, which uses
g_thread_new ("dconf worker", ...), and g_thread_new uses prctl
(PR_SET_NAME).  

 

