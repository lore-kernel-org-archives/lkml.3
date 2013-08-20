Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab3HTK0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:26:37 -0400
Received: from mail-out5.uio.no ([129.240.10.17]:55390 "EHLO mail-out5.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3HTK0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:26:35 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 06:26:34 EDT
Message-ID: <1376993427.2576.17.camel@localhost>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
From: Georgios Magklaras <georgios@biotek.uio.no>
To: Arend van Spriel <arend@broadcom.com>
Cc: Tom Gundersen <teg@jklm.no>, Felix Fietkau <nbd@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 20 Aug 2013 12:10:27 +0200
In-Reply-To: <52133DD9.8010902@broadcom.com>
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
	 <20130820000336.GA15548@kroah.com>
	 <CAG-2HqUkxvtJNGx0UbZVfaBNvSY-OU+=anSSnroS3AfSR9H0SA@mail.gmail.com>
	 <20130820002822.GA18023@kroah.com> <5212F6E8.3090107@openwrt.org>
	 <52132589.5000306@broadcom.com>
	 <CAG-2HqVo+Jn4QsmErCVcqgS6LcxvXESVWHHCp5BGapcv0A_+Ww@mail.gmail.com>
	 <52133DD9.8010902@broadcom.com>
Organization: University of Oslo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 9 sum msgs/h 1 total rcpts 2557 max rcpts/h 36 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-6.2, required=5.0, autolearn=disabled, RP_MATCHES_RCVD=-1.167,UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1F4FB34CE0B0BC11924947252739C6856EB84441
X-UiO-SPAM-Test: remote_host: 129.240.235.130 spam_score: -61 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 3777 max/h 18 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I verify the same issue on a Latitude E6520 running both the
vanilla/clean and the Fedora 19 specific kernels. I thought it was the
NVIDIA/nouveau driver and I reproduce by switching to non graphical mode
and performing scp transfers.

GM


On Tue, 2013-08-20 at 11:58 +0200, Arend van Spriel wrote:
> On 08/20/2013 10:36 AM, Tom Gundersen wrote:
> > On Tue, Aug 20, 2013 at 4:15 PM, Arend van Spriel <arend@broadcom.com> wrote:
> >> On 08/20/2013 06:56 AM, Felix Fietkau wrote:
> >>>
> >>> On 2013-08-20 2:28 AM, Greg Kroah-Hartman wrote:
> >>>>
> >>>> On Tue, Aug 20, 2013 at 08:26:11AM +0800, Tom Gundersen wrote:
> >>>>>
> >>>>> On Tue, Aug 20, 2013 at 8:03 AM, Greg Kroah-Hartman
> >>>>> <gregkh@linuxfoundation.org> wrote:
> >>>>>>
> >>>>>> On Tue, Aug 20, 2013 at 07:59:47AM +0800, Tom Gundersen wrote:
> >>>>>>>
> >>>>>>> Hi guys,
> >>>>>>>
> >>>>>>> Starting with 3.10.6 (and still present in .7) I get an oops on
> >>>>>>> connecting to the network.
> >>>>>>>
> >>>>>>> The attached picture shows the oops. In case it does not reach the ML,
> >>>>>>> the top of the call trace reads:
> >>>>>>>
> >>>>>>> brcms_c_compute_rtscts_dur
> >>>>>>> brcms_c_ampdu_finalize
> >>>>>>> ampdu_finalize
> >>>>>>> dma_txfast
> >>>>>>> brcms_c_txfifo
> >>>>>>> brcms_c_sendpkt_mac80211
> >>>>>>> brcms_ops_tx
> >>>>>>> __ieee80211_tx
> >>>>>>>
> >>>>>>> I bisected the problem and the first bad commit is
> >>>>>>>
> >>>>>>> commit ef47a5e4f1aaf1d0e2e6875e34b2c9595897bef6
> >>>>>>> Author: Felix Fietkau <nbd@openwrt.org>
> >>>>>>> Date:   Fri Jun 28 21:04:35 2013 +0200
> >>>>>>>
> >>>>>>>       mac80211/minstrel_ht: fix cck rate sampling
> >>>>>>>
> >>>>>>>       commit 1cd158573951f737fbc878a35cb5eb47bf9af3d5 upstream.
> >>>>>>>
> >>>>>>> Reverting it on top of .7 fixes the problem.
> >>>>>>>
> >>>>>>> I had the same (I suppose) problem on mainline some time ago, but I
> >>>>>>> have not bisected it, verified that the problem still occurs there, or
> >>>>>>> checked if reverting the upstream patch fixes it. I'd be happy to do
> >>>>>>> that if it would help though.
> >>>>>>>
> >>>>>>> Let me know if you need any more information.
> >>>>>>
> >>>>>>
> >>>>>> Do you have this same problem with 3.11-rc6 as well?
> >>>>>
> >>>>>
> >>>>> Yes, I just confirmed. I also confirmed that reverting the mainline
> >>>>> commit on top of -rc6 fixes the problem.
> >>>>
> >>>>
> >>>> Great, thanks.
> >>>>
> >>>> Felix and Johannes, any chance we can get this reverted in Linus tree
> >>>> soon, and push that revert back to the 3.10 stable tree as well?
> >>>
> >>> I'd like to avoid a revert, since that will simply replace one set of
> >>> issues with another. Let's limit the use of the feature that brcmsmac
> >>> can't handle to drivers that are known to work with it. Tom, Please
> >>> test this patch to see if it fixes your issue.
> >>
> >>
> >> Hi Felix,
> >>
> >> I have been diving into root causing why brcmsmac can not handle cck
> >> fallback rates, because it should. Maybe it is better to flag no cck support
> >> and only change brcmsmac.
> >
> > Hi Arend,
> >
> > In case you cannot reproduce, let me know if I can help with testing patches.
> 
> So far I have not been able to reproduce it. I have a patch to avoid the 
> oops, but the transmit of the related frames will fail in the device so 
> it is not a real fix. I will let you you know.
> 
> Regards,
> Arend
> 
> > Cheers,
> >
> > Tom
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


