Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaGQAoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:44:44 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:57036 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaGQAol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140716184736.GC10633@kroah.com>
References: <20140715091144.GA19080@devel.8.8.4.4>
	<20140715152929.GA8844@kroah.com>
	<CAHb8M2B0EAjDr=yTfWQ_YsRcX9JumU8rUQ1mQeoqMWeBbY4gnQ@mail.gmail.com>
	<20140715235058.GB32651@kroah.com>
	<CAHb8M2BxN0hwJErX5F7E0KeoiPFBvnkGT7eQSXxHktRQCHv0Dw@mail.gmail.com>
	<20140716184736.GC10633@kroah.com>
Date: Thu, 17 Jul 2014 09:44:41 +0900
Message-ID: <CAHb8M2BRORKz4OTAx5P+m5Ccpc9ei_WjegO5W2aEGrKQNGZ0rg@mail.gmail.com>
Subject: Re: [PATCH 6/8 V2] staging: dgap: remove unneeded dgap_err()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-17 3:47 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Jul 16, 2014 at 06:26:17PM +0900, DaeSeok Youn wrote:
>> 2014-07-16 8:50 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> > On Wed, Jul 16, 2014 at 08:21:30AM +0900, DaeSeok Youn wrote:
>> >> Hi,
>> >>
>> >> 2014-07-16 0:29 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> >> > On Tue, Jul 15, 2014 at 06:11:44PM +0900, Daeseok Youn wrote:
>> >> >> The dgap_err() is printing a message with pr_err(),
>> >> >> so all those are replaced.
>> >> >>
>> >> >> Use definition "pr_fmt" and then all of "dgap:" in
>> >> >> the beginning of print messages are removed.
>> >> >>
>> >> >> And also removed "out of memory" message because
>> >> >> the kernel has own message for that.
>> >> >>
>> >> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> >> >> ---
>> >> >> V2: use pr_fmt "dgap:" prefix on print message on dgap.
>> >> >>     remove "out of memory" message.
>> >> >>
>> >> >>     Adds Mark to TO list and CC list for checking send
>> >> >>     this email properly to him.
>> >> >>
>> >> >>  drivers/staging/dgap/dgap.c |  306 +++++++++++++++++++------------------------
>> >> >>  1 files changed, 133 insertions(+), 173 deletions(-)
>> >> >>
>> >> >> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>> >> >> index 06c55cb..9e750fb 100644
>> >> >> --- a/drivers/staging/dgap/dgap.c
>> >> >> +++ b/drivers/staging/dgap/dgap.c
>> >> >> @@ -41,6 +41,8 @@
>> >> >>   */
>> >> >>  #undef DIGI_CONCENTRATORS_SUPPORTED
>> >> >>
>> >> >> +#define pr_fmt(fmt) "dgap: " fmt
>> >> >> +
>> >> >>  #include <linux/kernel.h>
>> >> >>  #include <linux/module.h>
>> >> >>  #include <linux/pci.h>
>> >> >> @@ -153,7 +155,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
>> >> >>  static int dgap_gettok(char **in);
>> >> >>  static char *dgap_getword(char **in);
>> >> >>  static int dgap_checknode(struct cnode *p);
>> >> >> -static void dgap_err(char *s);
>> >> >>
>> >> >>  /*
>> >> >>   * Function prototypes from dgap_sysfs.h
>> >> >> @@ -815,7 +816,7 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
>> >> >>       if (ret)
>> >> >>               goto free_brd;
>> >> >>
>> >> >> -     pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
>> >> >> +     pr_info("board %d: %s (rev %d), irq %ld\n",
>> >> >>               boardnum, brd->name, brd->rev, brd->irq);
>> >> >
>> >> > Almost all of the pr_*() calls in this driver should be converted over
>> >> > to use dev_*() calls instead.  And some of them, like this one, should
>> >> > be removed entirely (no need for a driver to be "noisy" when a device
>> >> > for it is found, it should be quiet if at all possible, unless something
>> >> > went wrong.)
>> >> >
>> >> > So can you do that here instead?  I've applied the earlier patches in
>> >> > this series, and stopped here.
>> >> OK. I can. pr_*() calls are replaced with dev_*() calls.
>> >> And also removes some of print message which are useless like "out
>> >> of memory"
>> >
>> > Yes, please do that, that would be great.
>> I have been working to change pr_*() to dev_*(), but dgap_parse() has no
>> "struct device" for using dev_*(). If dgap_parse still need for this driver,
>> it need to take a parameter for using dev_*(), it may be "pdev" but
>> configuration
>> file doesn't need to parse in kernel at all, dgap_parse() will be removed.
>
> For now keep the parsing code, and find a device to use, there should be
> one somewhere, as it is a driver :)
OK. find a device to use for dev_*() and makes a patch for this.

thanks.

regards,
Daeseok Youn.
>
> thanks,
>
> greg k-h
