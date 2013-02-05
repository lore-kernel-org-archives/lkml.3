Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3BEGfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:35:43 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39747 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3BEGfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:35:40 -0500
MIME-Version: 1.0
In-Reply-To: <51109F20.60205@zytor.com>
References: <CAMNxYsyRRaHheOPBR18No4EFQ3=sedCmP85X-Hyg2bjapjtw+A@mail.gmail.com>
	<51109F20.60205@zytor.com>
Date: Tue, 5 Feb 2013 12:05:40 +0530
Message-ID: <CAMNxYszE1EVRMvAtteckbY5=kga3c7-B9Nyuz+=s4ur7KqW+9A@mail.gmail.com>
Subject: Re: ISO/IEC 7811 driver for Magnetic Cards.
From: Priyaranjan Das <priyaranjan456789@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Feb 5, 2013 at 11:26 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/04/2013 09:08 PM, Priyaranjan Das wrote:
>>
>> Hi All,
>>
>> I am working on a Magnetic Card driver which would support ISO/IEC
>> 7811 standard for track data. Can anyone tell me if such an
>> implementation is available in existing kernel or not? I am basically
>> looking for  code that implements the ISO/IEC 7811 standard or any
>> similar standards.
>>
>
> You have to write a driver for whatever reader/writer you are using.  A lot
> of them simply show up as a USB HID (i.e. a keyboard) and thus don't need
> any driver at all.
>

Thanks for your reply!

However my question was more of related to ISO/IEC 7811 standard, As
this is the format of the data read from the magnetic card. I wish to
know whether any such module is there in the Linux kernel currently
which works to decode the data as per as these ISO standards.

For e.g,

The first track read from a magnetic card could be as per below
standard format :

Track 1, Format :
Start sentinel — one character (generally '%')
Format code="B" — one character (alpha only)
Primary account number (PAN) — up to 19 characters. Usually, but not
always, matches the credit card number printed on the front of the
card.
Field Separator — one character (generally '^')
Name — two to 26 characters
Field Separator — one character (generally '^')
Expiration date — four characters in the form YYMM.
Service code — three characters
Discretionary data — may include Pin Verification Key Indicator (PVKI,
1 character), PIN Verification Value (PVV, 4 characters), Card
Verification Value or Card Verification Code (CVV or CVC, 3
characters)
End sentinel — one character (generally '?')
Longitudinal redundancy check (LRC) — it is one character and a
validity character calculated from other data on the track.
