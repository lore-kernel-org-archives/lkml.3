Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaJRPml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:42:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54221 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaJRPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:42:37 -0400
Date: Sat, 18 Oct 2014 17:42:11 +0200
From: Heinz Diehl <htd+ml@fritha.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Gleb Natapov <gleb@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi.kivity@gmail.com>, stefano.stabellini@eu.citrix.com,
        Laszlo Ersek <lersek@redhat.com>, KVM list <kvm@vger.kernel.org>,
        konstantin@linuxfoundation.org
Subject: Re: new GPG key
Message-ID: <20141018154211.GA4426@fritha.org>
References: <432661354.65688167.1413642451475.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <432661354.65688167.1413642451475.JavaMail.zimbra@redhat.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.23+15 (3a46874d5845) (2014-03-12)
X-Provags-ID: V02:K0:Uqa8gyorqyJo+wQZpD3913dtzIss+3wxQGh7cRw4fNu
 PvJIg6eKSLkcJy+T4BDBrXjeO2n8/ZAc7TVEAes9iT49HVC64z
 33x9AwZJReYGZ/JGWlhDeIQcHsQMR8emPsMwrj4fcpyNzyiG8t
 Yr468nAQOZ+ci7FjM8ftTlLMp4h+nx7UmaYg1f1zHs3lZyr4tR
 Z8SpxHDYeuOlYzkEbwbxMHxNJkOEbKwozQGSwdgpNzYwOeWSu4
 XyjGFFr+ByVmO+KuY/2Xv7Bpa/VvahouRC6cfzSXNAZZIsU7LM
 cGEE/RTcCYdQAVe6T9hdbP9lKh1nUl3scG1Mx4s2EroV56nzIy
 uEEAQrFgj+yxgwU6OUIs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.2014, Paolo Bonzini wrote: 

> 5) Get a smartcard or a Yubikey NEO and put the subkeys on it; replace
> subkeys with stubs on your usual working machines, especially laptops. It
> gives you two factor authentication for free, and can also be used for
> SSH if you add a third subkey.

AFAICS, a lot of the lkml people use the mutt MUA, which does not have
any password encryption natively. In this case, the smartcard
has another advantage: you can have your email password encrypted 
and use it without having to enter a long and complicated passphrase.
In case your laptop gets stolen while travelling, the password to your
email is protected.

Here's what I did:

1. Generate a password file and assign the password to a variable.

touch .my-pw
echo "set my_pw_imap = \"your-long-and-random-password\"" > .my-pw

2. Encrypt this file to your own public key and shred the unencrypted textfile
3. Source the password file into .muttrc and set the imap password
   variable by writing something like this into your .muttrc:

 source "gpg2 -dq $HOME/.my-pw.asc |"
 set imap_pass=$my_pw_imap

Now, if you start mutt and it connects to your IMAP server, you'll be
prompted for your smartcards PIN, and that's it. In case your
laptop gets stolen while you're travelling and you don't have access
to the net (because all the other things in your bag like your mobile 
also got stolen), it will spare you the situation where the thief 
already had logged into your email and changed your password when 
you finally managed to connect to the net again.

Sorry for being OT, but I have encountered such a situation before and
it got me into serious trouble, so I dared to share this with you.

