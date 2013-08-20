Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3HTR5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:57:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3HTR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:56:59 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nRXi7Rq_KXAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=cxZRFzV95EEA:10 a=3nbZYyFuAAAA:8 a=mK6Fwv8PAAAA:8 a=W85OJUbg_X7pwaj0RBwA:9 a=CjuIK1q_8ugA:10 a=6y3E1heEoQIA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 13:56:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol for
 communication between a server and clients
Message-ID: <20130820135658.5a5d6e28@gandalf.local.home>
In-Reply-To: <20130819094639.26597.44449.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094639.26597.44449.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 18:46:39 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> This message protocol is incompatible with the previous unstructured message
> protocol. So, if an old(new)-version client tries to connect to an
> new(old)-version server, the operation should be stopped.
> 

I'm a stickler for backward compatibility. I'm all for extensions.

I know this will just complicate things, but I don't mind that. What
should happen is, it should try to connect with the new protocol, if it
fails due to an older server, then it needs to fall back to the older
method, without the added features. We can freeze the older method if
need be. But I will not let a newer trace-cmd become incompatible with
an older version. I worked hard to keep it that way. There's only a few
exceptions to that.

Note, an older client needs to also work as is with a newer server.

Anyway, the old way only needs to stay the same, it does not need added
features. For that, a switch to the new way is needed.

If you need help in accomplishing this, I'll work with you on that.

Thanks!

-- Steve

