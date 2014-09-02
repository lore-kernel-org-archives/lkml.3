Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaIBTSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:18:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:44703 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbaIBTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <1409684570.15984.6.camel@localhost>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	<CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	<20140829195339.GA9780@kria>
	<1409363489.2980.17.camel@localhost>
	<CAHA+R7ODa+LrdwSrS7HcBfwwq8_fpj-Ld0OCDtcOqkpCdZCvxg@mail.gmail.com>
	<1409680684.972417.162793869.03CF8A61@webmail.messagingengine.com>
	<CAHA+R7Mwy1SCpEUgGf9BdLEro6N-3t89KU=xL0iuzgOppXELrQ@mail.gmail.com>
	<1409681914.978561.162800349.5A7FA784@webmail.messagingengine.com>
	<CAHA+R7MMe+O9-sNHQvgOO78tBzDy+hO+GtJFsuJPKx0eG6eMaw@mail.gmail.com>
	<1409684570.15984.6.camel@localhost>
Date: Tue, 2 Sep 2014 12:18:32 -0700
Message-ID: <CAHA+R7OtFHZBxdq836QOmErvijYEH5uO30RW5vq9v5jBQkPasQ@mail.gmail.com>
Subject: Re: RTNL: assertion failed at net/ipv6/addrconf.c (1699)
From: Cong Wang <cwang@twopensource.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Tommi Rantala <tt.rantala@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 12:02 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
>
> If fixes tag is well researched, it won't point to the addition of
> ASSERT_RTNL() but your patch would help to discover a bug somewhere else
> in the stack.
>
> I think for this patch a fixes-tag is hard to find because it is hard to
> find because it dates back to the beginning of the git history IMHO.
>

As I replied to Eric, this warning is probably caused by
the following commit:

commit c15b1ccadb323ea50023e8f1cca2954129a62b51
Author: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date:   Thu Mar 27 18:28:07 2014 +0100

    ipv6: move DAD and addrconf_verify processing to workqueue


HOWEVER, you can definitely argue that the code without your
ASSERT_RTNL() was already broken, it's a little hard to tell without
digging more, that might date back to the beginning of git as you said.

For safety, I think we can simply assume it's that commit to be fixed
so that we don't fix older kernels until someone really reports a bug.
