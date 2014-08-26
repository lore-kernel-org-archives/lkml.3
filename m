Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbaHZMfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:35:11 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34639 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaHZMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:34:14 -0400
Message-ID: <53FC7EC1.9070401@gmail.com>
Date: Tue, 26 Aug 2014 08:34:09 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>, linux-kernel@vger.kernel.org
Subject: Re: Documentation for init
References: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>
In-Reply-To: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>
x-hashcash: 1:21:140826:shea@shealevy.com::93c0d7b7ad30c505874094d05ee02745:a76a90daf2f1fd82
x-hashcash: 1:21:140826:linux-kernel@vger.kernel.org::eb3b6771290fc0368d9586b5a7385cf7:8285a70f5a104fbc
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-26 01:48, Shea Levy wrote:
> Hi all,
> 
> Is there any official documentation of the init process? I'm
> specifically interested in the process state at kernel handoff (argv,
> envp, open fds, etc.) as well as any special properties pid 1 has
> (parent of all orphans, anything else?).
> 
> Thanks,
> Shea Levy
> 
> P.S. I am not subscribed to LKML, please CC me in responses
This is following is just my understanding based on what I have seen and
read, and I may well be totally wrong on some points (if that is the
case, I would love to know about it, I'm always trying to learn more).

As far as I can tell, the argv that gets passed to the init process is
the concatenation of all arguments on the kernel command-line that the
kernel doesn't recognize or parse.  A lot of LiveCD's make use of this
to control hardware detection and module loading.  The only open file
descriptors (i believe, I may be wrong) are 0, 1, and 2, all pointing at
/dev/console.

As for special properties:
 * Parent of all orphans
 * Doesn't have a session ID until it calls setsid() (not certain about
this one)
 * Calling exit() will cause either a reboot or possibly a panic (I
think that this is dependent on the argument passed to exit())
 * Not catching a fatal signal will cause a panic (this means that
sending SIGKILL and SIGABRT to PID 1 will always cause a panic).
 * Has a PPID of 0, only other process like this is kthreadd
 * Becomes the parent of most X programs (almost all of them dissociate
very quickly from whatever started them.
