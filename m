Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab3IKT0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:26:02 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45598 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3IKT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130911192250.GF25896@mwanda>
References: <20130911044116.GA17294@www.outflux.net>
	<1378875632.606.5.camel@joe-AO722>
	<CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
	<20130911093118.GD25896@mwanda>
	<CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
	<20130911192250.GF25896@mwanda>
Date: Wed, 11 Sep 2013 12:26:00 -0700
X-Google-Sender-Auth: I_8KN7Jh722qmYJGDbULbz3CH-M
Message-ID: <CAGXu5jJZ3WY1cTCZc6QJtyE+FkVV-XBaQGqszHW1K52e_qAKvA@mail.gmail.com>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
From: Kees Cook <keescook@chromium.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Lidza Louina <lidza.louina@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Tushar Behera <tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 12:22 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Wed, Sep 11, 2013 at 11:19:11AM -0700, Kees Cook wrote:
>> On Wed, Sep 11, 2013 at 2:31 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Tue, Sep 10, 2013 at 10:19:17PM -0700, Kees Cook wrote:
>> >> In the former case, format characters will get processed by the
>> >> sprintf logic. In the latter, they are printed as-is. In this specific
>> >> case, if there was a way to inject strings like "ohai %n" into the
>> >> msgbuf string, the former would actually attempt to resolve the %n. In
>> >> the simple case, this could lead to Oopses, and in the unlucky case,
>> >> it could allow arbitrary memory writing and execution control.
>> >>
>> >> http://en.wikipedia.org/wiki/Uncontrolled_format_string
>> >
>> > The kernel ignores %n so hopefully it can't actually write to memory.
>>
>> I wish! This is not the case, though. See FORMAT_TYPE_NRCHARS in
>> lib/vsprintf.c's vsnprintf().
>>
>> $ git grep '%n' | wc -l
>> 111
>>
>
> Hm...  That's unfortunate.  The comments were shifted around so it says
> it's ignored but it's not.

Outside of scanf, there are very few uses, though:

$ git grep %n | grep print
...
net/phonet/socket.c:            seq_printf(seq, "%s%n", "pt  loc  rem
rs st tx_queue rx_queue "
net/phonet/socket.c:            seq_printf(seq, "%s%n", "rs   uid inode", &len);
net/phonet/socket.c:            seq_printf(seq, "%02X %5u %lu%n",
net/sctp/objcnt.c:      seq_printf(seq, "%s: %d%n", sctp_dbg_objcnt[i].label,

-Kees

-- 
Kees Cook
Chrome OS Security
