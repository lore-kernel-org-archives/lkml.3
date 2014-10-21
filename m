Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaJUQZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:25:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36557 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbaJUQZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:25:29 -0400
Message-ID: <544688E6.9050105@ti.com>
Date: Tue, 21 Oct 2014 11:25:10 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>
CC: <torvalds@linux-foundation.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Matt Porter <mporter@linaro.org>, LeyFoon Tan <lftan.linux@gmail.com>,
        Bjorn Andersson <bjorn@kryo.se>, Mark Brown <broonie@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Alexandre Torgue <alexandre.torgue@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] New Mailbox framework for 3.18
References: <CAJe_Zhf73TXxAjBq_cCJB_oBC1Ff_ErN7TP4HsO-_BzhiPZkGQ@mail.gmail.com> <CAJe_ZhcXTp6phuS=8nYuXTD3yUHsu7QKap85iVgfcZsrmOK59g@mail.gmail.com> <3078007.YbCSC1R6J1@wuerfel>
In-Reply-To: <3078007.YbCSC1R6J1@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/21/2014 02:43 AM, Arnd Bergmann wrote:
> On Monday 20 October 2014 15:23:38 Jassi Brar wrote:
>> On 8 October 2014 11:09, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>> Hi Linus,
>>>
>>> A framework for Mailbox controllers and clients have been cooking for
>>> more than a year now. Everybody in the CC list had been copied on
>>> patchset revisions and most of them have made sounds of approval,
>>> though just one concrete Reviewed-by. The patchset has also been in
>>> linux-next for a couple of weeks now and no conflict has been
>>> reported. The framework has the backing of at least 5 platforms,
>>> though I can't say if/when they upstream their drivers (some
>>> businesses have 'changed').
>>>
>> Hi Linus,
>>   While I was speculating on the reasons why you were not merging the
>> patchset - not enough Acked-Bys, you want it via asoc, my git server
>> down (I am not aware) or you just forgot in the unlikely case - I
>> missed the window.
>>  There are couple of platforms waiting for the api to get upstream and
>> now I have the devs on my back. Assuming I messed up the pull request
>> somehow, may I know how?
> 
> Jassi,
> 
> I assume a contributing factor here was that you rebased the tree
> just before submission, which is always a bad sign.
> 
> There is a small chance that Linus will still pull this for v3.18, as he
> said that he'd take a few things that have been submitted in time. If
> not, please rebase once more on top of v3.18-rc1 and send a pull request
> to arm@kernel.org so we can put it into arm-soc for 3.19.
> 
> Linus, 
> 
> I think it would be good to have it, I had an earlier version in arm-soc
> a couple of merge windows ago but ended up not submitting it back then
> because of a last-minute problem. All issues have been resolved since, 
> and we have a number of platforms that want to add drivers on top of
> the framework.

In terms of users, the OMAP mailbox adaptation patches to this framework
is ready [1], and this is one of the main dependencies to achieve PM
suspend/resume on the TI AM335/AM437 SoCs. I would have to rebase the
patches onto the appropriate -rc with the framework patches in, as the
remaining mailbox dependencies did make it into 3.18-rc1. I was
initially hoping that this would be 3.18-rc1, and the OMAP patches to
make it into 3.19, but if this is going to be 3.19, then the OMAP
adaptation can be baselined off an immutable mailbox framework branch,
and come through the arm-soc tree as well.

[1] http://marc.info/?l=linux-omap&m=141038447817775&w=2

regards
Suman

