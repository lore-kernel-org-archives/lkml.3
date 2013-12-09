Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab3LIIoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:44:10 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:44015 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab3LIIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131209082527.GA26950@kroah.com>
References: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
	<20131208140100.GA22793@kroah.com>
	<CABawtvO5YxH8J3d9Ea2ya3UUCEwjPWBRJaCJJMfovgmtPPBcRQ@mail.gmail.com>
	<20131209082527.GA26950@kroah.com>
Date: Mon, 9 Dec 2013 16:44:05 +0800
Message-ID: <CABawtvOdjncv7Zo29GbdGPm-ATsPNTVZqfje2qXTYeBRX=0w9A@mail.gmail.com>
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 4:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 09, 2013 at 09:43:16AM +0800, Ethan Zhao wrote:
>> On Sun, Dec 8, 2013 at 10:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Sun, Dec 08, 2013 at 07:31:02PM +0800, ethan.zhao wrote:
>> >> Should check debugfs initialization with debugfs_initialized() before using it,
>> >> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
>> >> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
>> >
>> > So?  It should "just work" without this check, right?  What happens if
>> > your patch isn't applied and debugfs isn't enabled?
>>
>> If debugfs isn't  configured, debugfs_initialized() and other
>> functions are defined as following,
>>
>> static inline bool debugfs_initialized(void)
>> {
>> return false;
>> }
>>
>> static inline struct dentry *debugfs_create_file(const char *name, umode_t mode,
>> struct dentry *parent, void *data,
>> const struct file_operations *fops)
>> {
>> return ERR_PTR(-ENODEV);
>> }
>>
>> static inline struct dentry *debugfs_create_dir(const char *name,
>> struct dentry *parent)
>> {
>> return ERR_PTR(-ENODEV);
>> }
>>
>> And the checking code in xen\debugfs.c xen_init_debugfs() will not
>> work, the return value is not NULL.
>> d_xen_debug = debugfs_create_dir("xen", NULL);
>>
>> if (!d_xen_debug)
>> pr_warning("Could not create 'xen' debugfs directory\n");
>
> Which is just fine, what is wrong with this?

If we no check with debugfs_initialized(),  the above code should be
if  (!d_xen_debug || IS_ERR (d_xen_debug))
    pr_warning("Could not create 'xen' debugfs directory\n");

>
>> >
>> > greg k-h
>> >
>> >> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>> >
>> > Please put your "real" name here, not one with a '.' in it.
>>
>> The real name used in company is ethan.zhao@oracle.com,  but I
>> couldn't send and receive mails of
>> community with that mailbox for some reason you may know.
>
> I mean the "ethan.zhao" part, it should be "Ethan Zhao" :)

You got the my real name, thanks. :>

Ethan
>
> thanks,
>
> greg k-h
