Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3JXLRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:17:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44330 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab3JXLRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:17:42 -0400
X-Sasl-enc: 0fTK2Yzsp0BaQ5CeLN3bt0ofblic1zQz8BQC7i7hSQV8 1382613460
Date: Thu, 24 Oct 2013 09:17:37 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
Message-ID: <20131024111737.GC24862@khazad-dum.debian.net>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
 <1382304926-1641-2-git-send-email-prarit@redhat.com>
 <CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
 <5265A9A4.2000100@redhat.com>
 <CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
 <526706FC.2070105@redhat.com>
 <CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com>
 <5267A6CA.1000505@redhat.com>
 <5267BAE7.2090300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5267BAE7.2090300@redhat.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Prarit Bhargava wrote:
> After all this I completely forgot the problem I'm trying to solve here.  The
> issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
> is not found (that is the file is not found on disk), then EACH cpu waits 1
> minute and it takes 2 hours for a 120 cpu box to load the microcode module.

The proper fix seems to be teaching the concept of negative caching to the
microcode core/drivers, as it was pointed out elsewhere in the thread.
Negative caching should have a lifetime of "the current update-all-cores
request".

This would fix the absurd compound timeout delays, as on most systems it
will result in just one timeout (the first one).

That first timeout can be fixed by the user if they disable the userspace
firmware loader helper.  IMHO that might well be the best choice, as it is
already the way forward.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
