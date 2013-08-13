Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3HMMqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:46:47 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55064 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3HMMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:46:46 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <1376339161.15390.281.camel@Solace>
References: <1376316812-30346-1-git-send-email-lccycc123@gmail.com> <1376339161.15390.281.camel@Solace>
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Tue, 13 Aug 2013 08:46:25 -0400
X-Google-Sender-Auth: wF9jTS-9Xt1JGoQ7ziF0dQz9YI0
Message-ID: <CAPbh3rtHWmH5A4eyUcSq9ORastE4iUMTRpKsBrPdOK5+AGb=9Q@mail.gmail.com>
Subject: Re: [PATCH v1][RFC] drivers/xen, balloon driver numa support in kernel
To: Dario Faggioli <dario.faggioli@citrix.com>
Cc: Yechen Li <lccycc123@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 4:26 PM, Dario Faggioli
<dario.faggioli@citrix.com> wrote:
> Hi Yechen.
>
> Thanks for doing and sharing this part of the thing too.
>
> See what I already told you on xen-devel about Cc-ing the relevant
> people. For Linux as well, you can check at the MAINTAINERS file. This
> exact thing (i.e., who the actual maintainers are) is changing a bit
> right in these days... See this commit:
>
> http://git.kernel.org/cgit/linux/kernel/git/xen/tip.git/commit/?h=devel/for-jens-3.12&id=3eeef8f72a9365fe20f2c9d84b0afe60a20788cd
>
> On lun, 2013-08-12 at 22:13 +0800, Yechen Li wrote:
>>   This small patch adds numa support for balloon driver. Kernel version: 3.11-rc5
>>
> Mmm... Is that the case? I tried to apply it there and I have one failed
> hunk (#12). Anyway, could you please rebase it on the tip of some
> relevant git tree?
>
> Linus' tree would be fine, I guess:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
>
> However, since these kind of patches should probably go through Konrad's
> (or other Linux Xen maintainers) tree anyway, you could well base on top
> of:
>
> http://git.kernel.org/cgit/linux/kernel/git/konrad/xen.git/
>
> Or perhaps on some branch of this one here:
>
> http://git.kernel.org/cgit/linux/kernel/git/xen/tip.git/
>
> Konrad, David, would you find 5 minutes to explain Yechen which tree and
> which branch he should use, or point him to the appropriate
> documentation for understanding that? Thanks...

I would suggest he base it on top of devel/for-linus-3.12 for right now. That
branch will become 'stable/for-linus-3.12' which is then going to be
sent to Linus
for v3.12 merge window.

Obviously the patches will need to be reviewed before they go in.
>
>>   It's just a RFC version, since I'm waiting for the interface of numa topology.
>>   The balloon driver will read arguments from xenstore: /local/domain/(id)/memory
>> /target_nid, and settle the memory increase/decrease operation on specified
>> p-nodeID.
>>   To achieve this, I expand the page-list: ballooned_pages to an array:
>> ballooned_pages[MAX_BALLOONNODES], so that balloon can distinguish pages from
>> different node.
>>   For the guest without numa, this MAX_BALLOONNODES = 1 so that the balloon falls
>> back to a no-numa version.
>>

You also need to be backwards compatible in case those keys don't exist, or not
all of them exist. Or they have bogus values.
