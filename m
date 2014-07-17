Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaGQRnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:43:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61083 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaGQRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <3e019617640d1b07d0ab1c9a91455957c201d4cd.1405546879.git.luto@amacapital.net>
References: <cover.1405546879.git.luto@amacapital.net>
	<3e019617640d1b07d0ab1c9a91455957c201d4cd.1405546879.git.luto@amacapital.net>
Date: Thu, 17 Jul 2014 10:43:49 -0700
Message-ID: <CAKB9nXs=htVXQciEfXQ4tMnLJT8RemHoVs+dVGPWXN+rGbdk6g@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching
 feature bit
From: Andrew Honig <ahonig@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       case MSR_KVM_GET_RNG_SEED:
> +               get_random_bytes(&data, sizeof(data));
> +               break;

Should this be rate limited in the interest of conserving randomness?
If there ever is an attack on the prng, this would create very
favorable conditions for an attacker to exploit it.
