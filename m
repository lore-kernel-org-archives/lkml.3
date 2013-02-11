Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab3BKM6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:58:04 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48785 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3BKM6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:58:02 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC PATCH] xfrm: fix handling of XFRM policies mark and mask.
From: Romain KUNTZ <r.kuntz@ipflavors.com>
In-Reply-To: <1854603B-3AD1-4245-A8BA-53D841BCEA63@telecom-bretagne.eu>
Date: Mon, 11 Feb 2013 13:57:59 +0100
Cc: jamal <j.hadi123@gmail.com>, netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.hengli.com.au,
        Emmanuel THIERRY <emmanuel.thierry@telecom-bretagne.eu>,
        linux-kernel@vger.kernel.org, Jamal Hadi Salim <hadi@cyberus.ca>
Content-Transfer-Encoding: 8BIT
Message-Id: <9EFD8AF1-2EDC-4361-A6CA-52FD5D42ED9E@ipflavors.com>
References: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com> <20130205081232.GF23291@secunet.com> <51125744.3030905@gmail.com> <D4563759-CEC5-4F33-BF0A-9FA10716F8DF@telecom-bretagne.eu> <20130207104908.GA17794@secunet.com> <2BEAF521-7218-415B-98ED-EC0812903479@telecom-bretagne.eu> <20130207125437.GC17794@secunet.com> <1854603B-3AD1-4245-A8BA-53D841BCEA63@telecom-bretagne.eu>
To: Steffen Klassert <steffen.klassert@secunet.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

Do you plan to resubmit a patch to the mailing list or shall we take care of that?

Thank you,
Romain

On Feb 8, 2013, at 15:16 , Emmanuel Thierry <emmanuel.thierry@telecom-bretagne.eu> wrote:

> Hello,
> 
> Le 7 févr. 2013 à 13:54, Steffen Klassert <steffen.klassert@secunet.com> a écrit :
> 
>> On Thu, Feb 07, 2013 at 12:08:22PM +0100, Emmanuel Thierry wrote:
>>> 
>>> This is a nice idea, however you keep the insertion asymmetric. The usage of xfrm marks in non-conflicting cases will be made possible, but it stays disturbing for a user as the initial example will still have the same behavior:
>>> * Inserting the marked one then the unmarked will succeed
>>> * Inserting the unmarked then the marked one will fail
>>> This gives to the user the feeling of an indeterministic behavior of the xfrm module.
>> 
>> This was intended. Inserting the marked one then the unmarked
>> is a working scenario. Some users might rely on it, so we can't
>> change this as you proposed.
>> 
>> On the other hand, inserting the unmarked one then the marked
>> might result in a wrong policy lookup, so we can't allow this.
>> The only possibility we have, is inserting with different
>> priorites and that's what I'm proposing.
>> 
>> I fear we have to live with that asymmetric behaviour if
>> both policies have the same priority.
>> 
> 
> Ok, actually i understand the concern of backward compatibility you expose. It is true that users might be disturbed if we change such a behavior they would rely on.
> Anyway, i'm ok with your patch.
> 
> Best regards
> Emmanuel Thierry

-- 
Romain KUNTZ
IP flavors | http://www.ipflavors.com
+33 (0)6 61 29 50 52
r.kuntz@ipflavors.com



