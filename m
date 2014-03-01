Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaCAFst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:48:49 -0500
Received: from nm7-vm10.bullet.mail.gq1.yahoo.com ([98.136.218.217]:22475 "EHLO
	nm7-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbaCAFss convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:48:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 554638.29187.bm@omp1033.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iOtRlt4DFwLuCN0vl7HeoQJu1RVf3nQ+qu3BF/wWoaFIrYTMpVh2v3LjPLgoqYVla0hkevoNkznLG9IW492Mffd8ydOQkJgBhuQiPxQC0xSatciBgdv2hgyZERBjbDd+/W7KNe8kHwnmZ0rBGlo1788HVzhh4XI7O4DjSY4WaEA=;
X-YMail-OSG: d5M3bFUVM1k_bKCf8QQVfE7PpaKAVeGJWk6xOF83H7.Hz0D
 h6w_RYgKnUvnVmt1PeCrRQiyfIe5xyLHZC_lh6wQ6xXwfOqKeGte.QXg0_.c
 s41heLj2N72QsaUcWtFmsdsW81zlGQ.0qRVqSEn9EU0l.0.nUthbtpgcV0yh
 YEcifR8pnKCaevjuwRwfgucUwxfmyu5JkRcW7tMpNx.RTrcUK8zz173OyAoZ
 wozvzkbVJYV.jE3XpVVVWNrOYOI7URr6KPDaFCwQGZUyLwQjQxxD_ajQU5Iu
 U1qV6EoBKE58TX5hEs9gSCyzKhkmRHoK_LQRBCDjD9if6kCkrd_mMIhSkAdG
 IKztktDQ9DobQKkavPQ36GDlQwpgTr5Kzt4HQJM.gKc4YaMFej8xj63_Y.ov
 RxCUvzI3XSpNto5ZuoGjfyHTlUyhSMNF1D9yf6HvX5P4urAyrHkdtwfXq3Sg
 UWHjcqKmXyCsjLzjhnsmQEq61ax8J840ojqjEGxw9v39_zW2HTO8MwIfRPoq
 BwdcCq9TBhKNztSm8KdGLCcl8
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgRmVicnVhcnkgMjgsIDIwMTQgMTE6MjYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKCj4.T24gMjAxNC0wMi0yOCAwNzozNSwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.PiBTbWF0Y2ggbG9jYXRlZCBhIGhhbmRmdWwgb2Ygd2hpbGUgbG9vcHMgdGVzdGluZyByZWFkbCBjYWxscyBpbiBzNjI2LmMuCj4.IFNpbmNlIHRoZXNlIHdoaWxlIGxvb3BzIGRlcGVuZCBvbiByZWFkbCBzdWNjZWVkaW5nLCBpdCdzIHNhZmVyIHRvIG1ha2UKPj4gc3VyZSB0aGV5IHRpbWUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <5310C4CB.2060201@mev.co.uk>
Message-ID: <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Fri, 28 Feb 2014 21:48:47 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5310C4CB.2060201@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, February 28, 2014 11:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-02-28 07:35, Chase Southwood wrote:
>> Smatch located a handful of while loops testing readl calls in s626.c.
>> Since these while loops depend on readl succeeding, it's safer to make
>> sure they time out eventually.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> Ian and/or Hartley, I'd love your comments on this.  It seems to me that
>> we want these kinds of while loops properly timed out, but I want to make
>> sure I'm doing everything properly.  First off, s626_debi_transfer() says
>> directly that it is called from within critical sections, so I assume
>> that means that the new comedi_timeout() function is no good here, and
>> s626_send_dac() looked equally suspicious, so I opted for iterative
>> timeouts.  Is this correct?  Also, for these timeouts, I used a very
>> conservative 10000 iterations, would it be better to decrease that?
>
>Well 10000 iterations is an improvement on infinity!  If the hardware is 
>working, you'd expect it to go round a lot fewer iterations than that, 
>but if the hardware is broken all bets are off, especially if it is 
>generating interrupts.
>

Great, thanks!  I suppose I'll leave that number there then.

>
>> Also, do my error strings appear acceptable?
>
>Mostly.  There's a type in one of the strings that says "TLS" instead of 
>"TSL".
>

*Sigh* I promise I can type sometimes :P I'll get this corrected.

>
>> And finally, are timeouts here even necessary or helpful, or are there
>> any better ways to do it?
>
>In the case of s626_send_dac(), it doesn't seem to be used in any 
>critical sections, so it could make use of Hartley's comedi_timeout().
>
>Some of the timeout errors could be propagated, especially for 
>s626_send_dac() which is only reachable from very few paths.
>

Awesome, I'll swap all of my timeouts out for comedi_timeout() in s626_send_dac().
As for propagating the timeout errors, could you please clarify that a bit further?  Both of the functions
which I add timeouts inside of in this patch return void, and so in their current state they cannot return any error
values.  Would you like them (or at least s626_send_dac()) to instead return an error upon timeout/or success on success,
or am I just totally misunderstanding your meaning of propagate here?

>
>There are other infinite loops involving calls to the s626_mc_test() 
>function, but those could be dealt with by other patches.
>

Yeah, I saw those...I'll whip up a patch for them, just wanted to verify that everything looks pretty good here
before I started on that.  I'll have that right out!

Thanks,
Chase
>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=- 
