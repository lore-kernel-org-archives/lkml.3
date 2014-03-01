Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaCAFcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:32:05 -0500
Received: from nm27-vm5.bullet.mail.gq1.yahoo.com ([98.136.216.148]:31773 "EHLO
	nm27-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbaCAFcC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:32:02 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 24828.42718.bm@omp1088.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qrdEoNRBqhr+bOLC/vf70Ri0FQPI/Vgu0E7gTgkwomrAD0wGYLuh5UxVo8d0BckovMQPRiIZfJxM08UJc8DGbiStP8y1pO3gtdjMLm/oGiCyCDnUAU/3nDOLYJw98B8QVHXzZGpiTeJMXJmFYxxn6bm2Njn3YhBU8MiHykFH9BU=;
X-YMail-OSG: fDXqITAVM1nJ1jjp.nIwCDuAA9j51zulTQU5RohdjFXp.Ha
 n_Dvy..jjy8xqcVdsopiyykCr9i2xBs0PwkSRvloOFF.t7KV_6n955KkGaqd
 VVqr3cm8ktbXx1kr2JuS4gY9fQbVse.gi6Z4UeI2Qhpvu7e61zSUSfoTLl.L
 8wcgtaRyE3ZOpRy8WJpKW3W1LSY2vJ29Flas.J9ub_0AE.WOSgifPS.er2v3
 dL5S0Q0fMQnMieBtsdjy5ma4DgRccUaREOINckgs.YmFTUza.FQ7g3rCJd_X
 eFb6DI3kLygfIFelHq3Ay5pK0ddqTPpB973T8qHpIEfDDPqY9KKAN4tvIQyw
 rHB8db8KNKICepyYglYJoT2zzJfPWcjBmUH6z6YjLvr01guTHZcry.y6eL3X
 Tf4ji.Zafw7MLWcw5SlIpp43sC2mFfWcD.t6PkXFShFFn4EcfBfE9QwiGtUX
 2c4tmE4zizS3bwNgLqfWNsxcCkVGokrwfP5s2KUx.MTk8h2fdXi965z_jmOB
 FnWUUati6IftW5sivj0zuE_NI
X-Rocket-MIMEInfo: 002.001,Cgo.T24gRnJpZGF5LCBGZWJydWFyeSAyOCwgMjAxNCA0OjMxIFBNLCBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cgo.Pk9uIEZyaSwgRmViIDI4LCAyMDE0IGF0IDAzOjE1OjQ1QU0gLTA2MDAsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj4KPj4gVGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGEgc2ltcGxlIGhlbHBlciBmdW5jdGlvbiwgb3V0bF8xNTY0X3RpbWVyKCksIHRvCj4.IGFsbG93IHNldmVyYWwgbGluZXMgd2hpY2ggdmlvbGF0ZSB0aGUgY2hhcmFjdGVyIGxpbWl0IHRvIGIBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com> <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com> <20140228223228.GA22295@kroah.com>
Message-ID: <1393651921.19222.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Fri, 28 Feb 2014 21:32:01 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/2 v2] Staging: comedi: fix lines that are over 80 characters
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
In-Reply-To: <20140228223228.GA22295@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>On Friday, February 28, 2014 4:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

>>On Fri, Feb 28, 2014 at 03:15:45AM -0600, Chase Southwood wrote:
>>
>> This patch introduces a simple helper function, outl_1564_timer(), to
>> allow several lines which violate the character limit to be shortened.
>> A handful of other lines that are too long are appropriately split as
>> well.
>> 
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> 2: introduced outl_1564_timer() at the suggestion of Dan.
>>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 83 +++++++++++++---------
>>  1 file changed, 49 insertions(+), 34 deletions(-)>
>
>The Subject: doesn't match the patch content :(

Greg,
You're right and that's totally my bad!  In all honesty, I sent this as v2 of my original cleanup patch (without even
changing the subject :( ) when really, that was a mistake because it's pretty much a different patch entirely (although with
the same ultimate end goal).  It needs further changes (based on Dan's comments) anyway, so when I send in the next version,
the subject will be changed appropriately.  Sorry for my oversight, it won't happen again.

Thanks,
Chase

