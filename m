Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3FCKmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:42:09 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:39220 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3FCKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130603095714.GA23987@mwanda>
References: <1369978679.10556.36.camel@joe-AO722>
	<cover.1370048648.git.joe@perches.com>
	<92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
	<20130603095714.GA23987@mwanda>
Date: Mon, 3 Jun 2013 13:42:06 +0300
Message-ID: <CAHp75Vdri=6e5Jd8Qd29B7hx+mSjp5EzbooV8FA3MnXaoMGzwg@mail.gmail.com>
Subject: Re: [PATCH V2 2/8] pktcdvd: Convert printk to pr_<level>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:57 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, May 31, 2013 at 09:11:23PM -0700, Joe Perches wrote:
>> +static const char *sense_key_string(__u8 index)
>> +{
>> +     static const char *info[9] = {
>> +             "No sense", "Recovered error", "Not ready",
>> +             "Medium error", "Hardware error", "Illegal request",
>> +             "Unit attention", "Data protect", "Blank check"
>> +     };
>> +     if (index < 8)
>
> Off by one:
>
>         if (index < 9)

Perhaps
if (index < ARRAY_SIZE(info)) ?

I actually didn't test this, if it returns number of strings.

-- 
With Best Regards,
Andy Shevchenko
