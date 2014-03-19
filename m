Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaCSUSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:18:37 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:47499 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaCSUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140319180323.GG14929@pd.tnic>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140319180323.GG14929@pd.tnic>
Date: Wed, 19 Mar 2014 22:18:35 +0200
Message-ID: <CACV2jQCeDsJ_ekMPumrfcrEHsYfgH0v1E1aYBB6SzA0qDm_dWw@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 8:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>> This feature encodes Oops messages into a QR barcode that is scannable by
>> any device with a camera.
>>
>> If the config option for this feature is enabled, then when an Oops is
>> in progress, the printk() calls' strings are buffered. When the Oops
>> finishes, the buffer is compressed, encoded into a QR and then displayed
>> to frame buffer. The compression is done with zlib from lib/.
>>
>> Current issues:
>>  * the QR code is sometimes displayed on top of the console text,
>>    sometimes under it, thus making it unscannable
>>  * the compression rate could be better than what zlib offers
>>  * not tested for Oops messages issued from several CPUs
>>
>> As far as decoding is concerned, there are a lot of apps on mobile devices
>> that decode QR codes (just text mostly). In order to make this work, an
>> app which also decodes the QR code is needed. I will be working the next
>> couple of weeks on an Android app which scans the Oops encoding QR and
>> sends it to a server which keeps track of these Oopses that are sent to
>> it making a sort of stream of the latest Oopses. Any thoughts on what the best
>> workflow would be are more than welcomed.
>>
>> Also, if there are any suggestions on how to solve some of the issues,
>> they are more than welcomed.
>
> Definitely a great idea. Which tree is the patch against?
>
> Thanks.

I started working from Linus's source tree that's up on github. To be
more exact, version 3.14.0-rc2.

Thank you for taking interest in this!

--
Teodora

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
