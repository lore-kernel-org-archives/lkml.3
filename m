Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3B0OJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:09:31 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48203 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3B0OJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:09:29 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <512E1061.3030007@suse.cz>
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
	<512E1061.3030007@suse.cz>
Date: Wed, 27 Feb 2013 15:09:28 +0100
Message-ID: <CA+icZUV993buV4VYONW2xe=rkFYdnGUAKzOi9ftQfUHK4sFRjg@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>,
        Thorsten Glaser <tg@debian.org>, Alexander Wirt <formorer@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 2:55 PM, Michal Marek <mmarek@suse.cz> wrote:
> Sorry I missed this series. Max, can you have a look? I don't know the
> policies for debian package changelogs. The full series is at
> http://lkml.indiana.edu/hypermail/linux/kernel/1204.2/index.html#04252,
> but the remaining two patches are obvious.
>

[ CC mirabilos and formorer ]

[PATCH 1/3] kbuild, deb-pkg: Try to determine distribution

...was discussed in (hehe, so long ago) April 2012 on #grml IRC (a
Linux live-system based on Debian) with Thorsten Glaser and Alexander
Wirt.
Both cool guys (longterm Debian maintainers and admins) gave me
several good hints to make this a "proper" solution.
Maybe, they won't remember :-).

I switched from Debian/unstable to Ubuntu/precise these days and that
was the reason I wanted the correct $distribution in my generated
Debian kernel packages.

Might be I come back when Debian/wheezy is released... you never know :-).
Or I get an Amiga-3000 with Debian/m68k running... with DirOpus and
DPaint-IV, hahaha.

I was simply too lazy to place a rock-solid changelog.

- Sedat -

> Michal
>
> On 24.4.2012 00:16, Sedat Dilek wrote:
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>> ---
>>  scripts/package/builddeb |   15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
>> index eee5f8e..f5b56ac 100644
>> --- a/scripts/package/builddeb
>> +++ b/scripts/package/builddeb
>> @@ -172,9 +172,22 @@ else
>>  fi
>>  maintainer="$name <$email>"
>>
>> +# Try to determine distribution
>> +if [ -e $(which lsb_release) ]; then
>> +       codename=$(lsb_release --codename --short)
>> +       if [ "$codename" != "" ]; then
>> +             distribution=$codename
>> +       else
>> +             distribution="UNRELEASED"
>> +             echo "WARNING: The distribution could NOT be determined!"
>> +       fi
>> +else
>> +       echo "HINT: Install lsb_release binary, this helps to identify your distribution!"
>> +fi
>> +
>>  # Generate a simple changelog template
>>  cat <<EOF > debian/changelog
>> -linux-upstream ($packageversion) unstable; urgency=low
>> +linux-upstream ($packageversion) $distribution; urgency=low
>>
>>    * Custom built Linux kernel.
>>
>>
>
>
