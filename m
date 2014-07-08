Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaGHMvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:51:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaGHMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:51:42 -0400
Date: Tue, 8 Jul 2014 05:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Meredydd Luff <meredydd@senatehouse.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Message-ID: <20140708125138.GA4749@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com>
 <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
 <20140708120702.GB30459@infradead.org>
 <CAD=T17FQEZV+iy91wQAvAdd0PW2tsfjpU7atp-xeatm5sEGz5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=T17FQEZV+iy91wQAvAdd0PW2tsfjpU7atp-xeatm5sEGz5Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:48:27PM +0100, Meredydd Luff wrote:
> How would that work? The directory beneath which openat is looking is
> conveyed in the dfd argument itself. If I'm understanding this right,
> you'd have to pass a different value for "open relative to fd#5" and
> "open relative to fd#5, but beneath it only", which doesn't sound
> hugely elegant to me.

Yeah, it won't work for an explicit directory - I was thinking of
working relative to $CWD.

