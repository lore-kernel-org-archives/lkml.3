Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaF3LSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:18:51 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58260 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaF3LSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140630101137.GA31222@bark>
References: <1404122011-11409-1-git-send-email-geert+renesas@glider.be>
	<20140630101137.GA31222@bark>
Date: Mon, 30 Jun 2014 13:18:48 +0200
X-Google-Sender-Auth: Qwqm2U1ELKmJeTP7pN4qrBF3yZM
Message-ID: <CAMuHMdWFxifapG6yU9yeZO0UqxtXSrAxZQpdBwOv+=X3E1Jh3w@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Enable whitespace checks for DTS files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Joe Perches <joe@perches.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, Jun 30, 2014 at 12:11 PM, Andy Whitcroft <apw@canonical.com> wrote:
> On Mon, Jun 30, 2014 at 11:53:31AM +0200, Geert Uytterhoeven wrote:
>> When run on *.dtsi or *.dts files, the whitespace checks were skipped,
>> while they are valid for DTS files.  Hence stop skipping them.
>>
>> I ran checkpatch on all in-tree DTS files, and didn't notice any error or
>> warning messages that are inappropriate for DTS files.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>>  scripts/checkpatch.pl | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 010b18ef4ea0..9ae624942a84 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -2137,7 +2137,7 @@ sub process {
>>               }
>>
>>  # check we are in a valid source file if not then ignore this hunk
>> -             next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
>> +             next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
>
> I think it is this one here which lets the white space checks happen for
> your new file types ...
>
>>  #line length limit
>>               if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
>> @@ -2192,7 +2192,7 @@ sub process {
>>               }
>>
>>  # check we are in a valid source file C or perl if not then ignore this hunk
>> -             next if ($realfile !~ /\.(h|c|pl)$/);
>> +             next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
>
> ... so I am supprised to see you also changing this one.  Is there a
> check below here you wanted other than those stated in the patch
> commentary?

No, e.g. "check for space before tabs" (the one that triggered me) is below.

>>  # at the beginning of a line any tabs must come first and anything
>>  # more than 8 must use tabs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
