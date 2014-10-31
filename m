Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaJaJze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:55:34 -0400
Received: from svenfoo.org ([82.94.215.22]:52348 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbaJaJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:55:32 -0400
Message-ID: <54535C8F.30707@zonque.org>
Date: Fri, 31 Oct 2014 10:55:27 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, teg@jklm.no
Subject: Re: kdbus: add code for buses, domains and endpoints
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org> <20141031013922.GG7996@ZenIV.linux.org.uk>
In-Reply-To: <20141031013922.GG7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/31/2014 02:39 AM, Al Viro wrote:
> On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:
>> See Documentation/kdbus.txt for more details.
> 
> ... which has nothing whatsoever on object lifetime rules.

True. That document only describes the external API exposed by the
driver towards userspace.

> Could you
> folks please document that somewhere?  What pins what, what state
> transitions are possible, etc.

Hmm, I'll see whether I can write something up.

> BTW, the calling conventions for your foo_new() are annoying - instead of
> "return -E... or 0, storing the reference to new object in var parameter
> passed as the last argument", could you please just return ERR_PTR(-E...)
> on error, a pointer to new object on success and to hell with those
> struct foo **foo in the argument lists?

No problem at all. We'll change that around.


Thanks for your feedback, much appreciated!

Daniel

