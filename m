Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3JKFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:25:57 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:45114 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751862Ab3JKFZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:25:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1535:1605:1606:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3868:3872:4117:4419:4605:4823:5007:6119:6261:7875:7903:7904:8603:9592:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13138:13231:13870,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: clock80_151aeb7f06e39
X-Filterd-Recvd-Size: 6473
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>, Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vsprintf: Just some neatening
Date: Thu, 10 Oct 2013 22:25:40 -0700
Message-Id: <c163504bd72d926b719d06abb4730ba2968a43ef.1381468961.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
References: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a few coding style nits:

o Leading spaces for tabs
o case indentation depth
o else and brace locations
o logical continuation placement

Several checkpatch bleats still exist,
mostly not worth changing.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c | 83 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ce55f52..dbc945b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -266,10 +266,10 @@ void put_dec_full4(char *buf, unsigned q)
 static
 unsigned put_dec_helper4(char *buf, unsigned x)
 {
-        uint32_t q = (x * (uint64_t)0x346DC5D7) >> 43;
+	uint32_t q = (x * (uint64_t)0x346DC5D7) >> 43;
 
-        put_dec_full4(buf, x - q * 10000);
-        return q;
+	put_dec_full4(buf, x - q * 10000);
+	return q;
 }
 
 /* Based on code by Douglas W. Jones found at
@@ -561,11 +561,11 @@ char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_sp
 	int i, n;
 
 	switch (fmt[1]) {
-		case '2': case '3': case '4':
-			depth = fmt[1] - '0';
-			break;
-		default:
-			depth = 1;
+	case '2': case '3': case '4':
+		depth = fmt[1] - '0';
+		break;
+	default:
+		depth = 1;
 	}
 
 	rcu_read_lock();
@@ -939,11 +939,11 @@ char *ip6_compressed_string(char *p, const char *addr)
 			else
 				*p++ = hex_asc_lo(hi);
 			p = hex_byte_pack(p, lo);
-		}
-		else if (lo > 0x0f)
+		} else if (lo > 0x0f) {
 			p = hex_byte_pack(p, lo);
-		else
+		} else {
 			*p++ = hex_asc_lo(lo);
+		}
 		needcolon = true;
 	}
 
@@ -1268,10 +1268,6 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 					 * 6:   000102...0f
 					 */
 		switch (fmt[1]) {
-		case '6':
-			return ip6_addr_string(buf, end, ptr, spec, fmt);
-		case '4':
-			return ip4_addr_string(buf, end, ptr, spec, fmt);
 		case 'S': {
 			const union {
 				struct sockaddr		raw;
@@ -1281,26 +1277,33 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 
 			switch (sa->raw.sa_family) {
 			case AF_INET:
-				return ip4_addr_string_sa(buf, end, &sa->v4, spec, fmt);
+				return ip4_addr_string_sa(buf, end, &sa->v4,
+							  spec, fmt);
 			case AF_INET6:
-				return ip6_addr_string_sa(buf, end, &sa->v6, spec, fmt);
+				return ip6_addr_string_sa(buf, end, &sa->v6,
+							  spec, fmt);
 			default:
-				return string(buf, end, "(invalid address)", spec);
-			}}
+				return string(buf, end, "(invalid address)",
+					      spec);
+			}
+		}
+		case '6':
+			return ip6_addr_string(buf, end, ptr, spec, fmt);
+		case '4':
+			return ip4_addr_string(buf, end, ptr, spec, fmt);
 		}
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
-	case 'V':
-		{
-			va_list va;
+	case 'V': {
+		va_list va;
 
-			va_copy(va, *((struct va_format *)ptr)->va);
-			buf += vsnprintf(buf, end > buf ? end - buf : 0,
-					 ((struct va_format *)ptr)->fmt, va);
-			va_end(va);
-			return buf;
-		}
+		va_copy(va, *((struct va_format *)ptr)->va);
+		buf += vsnprintf(buf, end > buf ? end - buf : 0,
+				 ((struct va_format *)ptr)->fmt, va);
+		va_end(va);
+		return buf;
+	}
 	case 'K':		/* see: Documentation/sysctl/kernel.txt */
 		switch (kptr_restrict) {
 		case 0:			/* None (default) */
@@ -1400,7 +1403,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	/* By default */
 	spec->type = FORMAT_TYPE_NONE;
 
-	for (; *fmt ; ++fmt) {
+	for (; *fmt; ++fmt) {
 		if (*fmt == '%')
 			break;
 	}
@@ -1433,9 +1436,9 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	/* get field width */
 	spec->field_width = -1;
 
-	if (isdigit(*fmt))
+	if (isdigit(*fmt)) {
 		spec->field_width = skip_atoi(&fmt);
-	else if (*fmt == '*') {
+	} else if (*fmt == '*') {
 		/* it's the next argument */
 		spec->type = FORMAT_TYPE_WIDTH;
 		return ++fmt - start;
@@ -1521,9 +1524,9 @@ qualifier:
 		return fmt - start;
 	}
 
-	if (spec->qualifier == 'L')
+	if (spec->qualifier == 'L') {
 		spec->type = FORMAT_TYPE_LONG_LONG;
-	else if (spec->qualifier == 'l') {
+	} else if (spec->qualifier == 'l') {
 		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_LONG;
 		else
@@ -1654,7 +1657,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 					if (str < end)
 						*str = ' ';
 					++str;
-
 				}
 			}
 			c = (unsigned char) va_arg(args, int);
@@ -1760,7 +1762,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
-
 }
 EXPORT_SYMBOL(vsnprintf);
 
@@ -1966,7 +1967,7 @@ do {									\
 			size_t len;
 
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
-					|| (unsigned long)save_str < PAGE_SIZE)
+			    || (unsigned long)save_str < PAGE_SIZE)
 				save_str = "(null)";
 			len = strlen(save_str) + 1;
 			if (str + len < end)
@@ -2392,11 +2393,11 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		if (is_sign && digit == '-')
 			digit = *(str + 1);
 
-		if (!digit
-		    || (base == 16 && !isxdigit(digit))
-		    || (base == 10 && !isdigit(digit))
-		    || (base == 8 && (!isdigit(digit) || digit > '7'))
-		    || (base == 0 && !isdigit(digit)))
+		if (!digit ||
+		    (base == 16 && !isxdigit(digit)) ||
+		    (base == 10 && !isdigit(digit)) ||
+		    (base == 8 && (!isdigit(digit) || digit > '7')) ||
+		    (base == 0 && !isdigit(digit)))
 			break;
 
 		if (is_sign)
-- 
1.8.1.2.459.gbcd45b4.dirty

