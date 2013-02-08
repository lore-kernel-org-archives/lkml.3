Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab3BHOQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:16:49 -0500
Received: from zproxy210.enst-bretagne.fr ([192.108.117.8]:51748 "EHLO
	zproxy210.enst-bretagne.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758547Ab3BHOQs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:16:48 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC PATCH] xfrm: fix handling of XFRM policies mark and mask.
From: Emmanuel Thierry <emmanuel.thierry@telecom-bretagne.eu>
In-Reply-To: <20130207125437.GC17794@secunet.com>
Date: Fri, 8 Feb 2013 15:16:45 +0100
Cc: jamal <j.hadi123@gmail.com>, Romain KUNTZ <r.kuntz@ipflavors.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        herbert@gondor.hengli.com.au,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jamal Hadi Salim <hadi@cyberus.ca>
Content-Transfer-Encoding: 8BIT
Message-Id: <1854603B-3AD1-4245-A8BA-53D841BCEA63@telecom-bretagne.eu>
References: <9E57ADA1-5770-47A8-8EBF-7FC262EEF1C7@ipflavors.com> <20130205081232.GF23291@secunet.com> <51125744.3030905@gmail.com> <D4563759-CEC5-4F33-BF0A-9FA10716F8DF@telecom-bretagne.eu> <20130207104908.GA17794@secunet.com> <2BEAF521-7218-415B-98ED-EC0812903479@telecom-bretagne.eu> <20130207125437.GC17794@secunet.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le 7 févr. 2013 à 13:54, Steffen Klassert <steffen.klassert@secunet.com> a écrit :

> On Thu, Feb 07, 2013 at 12:08:22PM +0100, Emmanuel Thierry wrote:
>> 
>> This is a nice idea, however you keep the insertion asymmetric. The usage of xfrm marks in non-conflicting cases will be made possible, but it stays disturbing for a user as the initial example will still have the same behavior:
>> * Inserting the marked one then the unmarked will succeed
>> * Inserting the unmarked then the marked one will fail
>> This gives to the user the feeling of an indeterministic behavior of the xfrm module.
> 
> This was intended. Inserting the marked one then the unmarked
> is a working scenario. Some users might rely on it, so we can't
> change this as you proposed.
> 
> On the other hand, inserting the unmarked one then the marked
> might result in a wrong policy lookup, so we can't allow this.
> The only possibility we have, is inserting with different
> priorites and that's what I'm proposing.
> 
> I fear we have to live with that asymmetric behaviour if
> both policies have the same priority.
> 

Ok, actually i understand the concern of backward compatibility you expose. It is true that users might be disturbed if we change such a behavior they would rely on.
Anyway, i'm ok with your patch.

Best regards
Emmanuel Thierry