Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592AbaDJIZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:25:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51618 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287AbaDJIZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:25:09 -0400
Message-ID: <53465558.8090300@gentoo.org>
Date: Thu, 10 Apr 2014 04:24:56 -0400
From: Jonathan Callen <jcallen@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/java.txt: add Java 7 support
References: <1396237634-6634-1-git-send-email-jcallen@gentoo.org> <5345737E.4050008@infradead.org>
In-Reply-To: <5345737E.4050008@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="lTWmNfReFlLEt9AVjWGvWTuV60q6jjC6N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lTWmNfReFlLEt9AVjWGvWTuV60q6jjC6N
Content-Type: multipart/mixed;
 boundary="------------080607050107040705030008"

This is a multi-part message in MIME format.
--------------080607050107040705030008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/09/2014 12:21 PM, Randy Dunlap wrote:
> On 03/30/2014 08:47 PM, Jonathan Callen wrote:
>> The sample wrapper currently fails on some Java 7 .class files.  This
>> updates the wrapper to properly handle those files.
>>
>> Signed-off-by: Jonathan Callen <jcallen@gentoo.org>
>=20
> Applied.  Thanks.
>=20
> How would I test this?
>=20

I have attached a hand-crafted HelloWorld.class file that fails unless th=
is patch is applied.  This
=2Eclass file intentionally has extra entries in its constant pool that a=
re not used by Java, but the
file does pass validation.

A complete disassembly of that file, showing the purpose of each byte, is=
 attached as HelloWorld.jj.

>=20
>> ---
>>  Documentation/java.txt | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/java.txt b/Documentation/java.txt
>> index e6a7232..4180205 100644
>> --- a/Documentation/java.txt
>> +++ b/Documentation/java.txt
>> @@ -188,6 +188,9 @@ shift
>>  #define CP_METHODREF 10
>>  #define CP_INTERFACEMETHODREF 11
>>  #define CP_NAMEANDTYPE 12
>> +#define CP_METHODHANDLE 15
>> +#define CP_METHODTYPE 16
>> +#define CP_INVOKEDYNAMIC 18
>> =20
>>  /* Define some commonly used error messages */
>> =20
>> @@ -242,14 +245,19 @@ void skip_constant(FILE *classfile, u_int16_t *c=
ur)
>>  		break;
>>  	case CP_CLASS:
>>  	case CP_STRING:
>> +	case CP_METHODTYPE:
>>  		seekerr =3D fseek(classfile, 2, SEEK_CUR);
>>  		break;
>> +	case CP_METHODHANDLE:
>> +		seekerr =3D fseek(classfile, 3, SEEK_CUR);
>> +		break;
>>  	case CP_INTEGER:
>>  	case CP_FLOAT:
>>  	case CP_FIELDREF:
>>  	case CP_METHODREF:
>>  	case CP_INTERFACEMETHODREF:
>>  	case CP_NAMEANDTYPE:
>> +	case CP_INVOKEDYNAMIC:
>>  		seekerr =3D fseek(classfile, 4, SEEK_CUR);
>>  		break;
>>  	case CP_LONG:
>>
>=20
>=20


--------------080607050107040705030008
Content-Type: application/java-vm;
 name="HelloWorld.class"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="HelloWorld.class"

yv66vgAAADMAHAoABgAMCQANAA4IAA8KABAAEQcAEgcAEwEABjxpbml0PgEAAygpVgEABENv
ZGUBAARtYWluAQAWKFtMamF2YS9sYW5nL1N0cmluZzspVgwABwAIBwAUDAAVABYBAA1IZWxs
bywgd29ybGQhBwAXDAAYABkBAApIZWxsb1dvcmxkAQAQamF2YS9sYW5nL09iamVjdAEAEGph
dmEvbGFuZy9TeXN0ZW0BAANvdXQBABVMamF2YS9pby9QcmludFN0cmVhbTsBABNqYXZhL2lv
L1ByaW50U3RyZWFtAQAHcHJpbnRsbgEAFShMamF2YS9sYW5nL1N0cmluZzspVg8CAAIQABkA
IQAFAAYAAAAAAAIAAQAHAAgAAQAJAAAAEQABAAEAAAAFKrcAAbEAAAAAAAkACgALAAEACQAA
ABUAAgABAAAACbIAAhIDtgAEsQAAAAAAAA==
--------------080607050107040705030008
Content-Type: text/plain; charset=UTF-8;
 name="HelloWorld.jj"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="HelloWorld.jj"

{
	u4 magic =3D cafebabe;
	u2 minor_version =3D 0000;
	u2 major_version =3D 0033;
	u2 constant_pool_count =3D 001c;
	cp_info constant_pool[constant_pool_count-1] =3D {
		{ // 0001 =3D Methodref java/lang/Object.<init>:()V
			u1 tag =3D 0a; // CONSTANT_Methodref
			u2 class_index =3D 0006; // Class java/lang/Object
			u2 name_and_type_index =3D 000c; // NameAndType <init>:()V
		},
		{ // 0002 =3D Fieldref java/lang/System.out:Ljava/io/PrintStream;
			u1 tag =3D 09; // CONSTANT_Fieldref
			u2 class_index =3D 000d; // Class java/lang/System
			u2 name_and_type_index =3D 000e; // NameAndType out:Ljava/io/PrintStre=
am;
		},
		{ // 0003 =3D String "Hello, world!"
			u1 tag =3D 08; // CONSTANT_String_info
			u2 string_index =3D 000f; // Utf8 Hello, world!
		},
		{ // 0004 =3D Methodref java/io/PrintStream.println:(Ljava/lang/String;=
)V
			u1 tag =3D 0a; // CONSTANT_Methodref
			u2 class_index =3D 0010; // Class java/io/PrintStream
			u2 name_and_type_index =3D 0011; // NameAndType println:(Ljava/lang/St=
ring;)V
		},
		{ // 0005 =3D Class HelloWorld
			u1 tag =3D 07; // CONSTANT_Class_info
			u2 name_index =3D 0012; // Utf8 HelloWorld
		},
		{ // 0006 =3D Class java/lang/Object
			u1 tag =3D 07; // CONSTANT_Class_info
			u2 name_index =3D 0013; // Utf8 java/lang/Object
		},
		{ // 0007 =3D Utf8 <init>
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0006;
			u1 bytes[] =3D {3c,69,6e,69,74,3e}; // <init>
		},
		{ // 0008 =3D Utf8 ()V
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0003;
			u1 bytes[] =3D {28,29,56}; // ()V
		},
		{ // 0009 =3D Utf8 Code
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0004;
			u1 bytes[] =3D {43,6f,64,65}; // Code
		},
		{ // 000a =3D Utf8 main
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0004;
			u1 bytes[] =3D {6d,61,69,6e}; // main
		},
		{ // 000b =3D Utf8 ([Ljava/lang/String;)V
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0016;
			u1 bytes[] =3D {28,5b,4c,6a,61,76,61,2f,6c,61,6e,67,2f,53,74,72,69,6e,=
67,3b,29,56}; // ([Ljava/lang/String;)V
		},
		{ // 000c =3D NameAndType <init>:()V
			u1 tag =3D 0c; // CONSTANT_NameAndType
			u2 name_index =3D 0007; // Utf8 <init>
			u2 descriptor_index =3D 0008; // Utf8 ()V
		},
		{ // 000d =3D Class java/lang/System
			u1 tag =3D 07; // CONSTANT_Class_info
			u2 name_index =3D 0014; // Utf8 java/lang/System
		},
		{ // 000e =3D NameAndType out:Ljava/io/PrintStream;
			u1 tag =3D 0c; // CONSTANT_NameAndType
			u2 name_index =3D 0015; // Utf8 out
			u2 descriptor_index =3D 0016; // Utf8 Ljava/io/PrintStream;
		},
		{ // 000f =3D Utf8 Hello, world!
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 000d;
			u1 bytes[] =3D {48,65,6c,6c,6f,2c,20,77,6f,72,6c,64,21}; // Hello, wor=
ld!
		},
		{ // 0010 =3D Class java/io/PrintStream
			u1 tag =3D 07;
			u2 name_index =3D 0017; // Utf8 java/io/PrintStream
		},
		{ // 0011 =3D NameAndType println:(Ljava/lang/String;)V
			u1 tag =3D 0c; // CONSTANT_NameAndType
			u2 name_index =3D 0018; // Utf8 println
			u2 descriptor_index =3D 0019; // Utf8 (Ljava/lang/String;)V
		},
		{ // 0012 =3D Utf8 HelloWorld
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 000a;
			u1 bytes[] =3D {48,65,6c,6c,6f,57,6f,72,6c,64}; // HelloWorld
		},
		{ // 0013 =3D Utf8 java/lang/Object
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0010;
			u1 bytes[] =3D {6a,61,76,61,2f,6c,61,6e,67,2f,4f,62,6a,65,63,74}; // j=
ava/lang/Object
		},
		{ // 0014 =3D Utf8 java/lang/System
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0010;
			u1 bytes[] =3D {6a,61,76,61,2f,6c,61,6e,67,2f,53,79,73,74,65,6d}; // j=
ava/lang/System
		},
		{ // 0015 =3D Utf8 out
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0003;
			u1 bytes[] =3D {6f,75,74}; // out
		},
		{ // 0016 =3D Utf8 Ljava/io/PrintStream;
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0015;
			u1 bytes[] =3D {4c,6a,61,76,61,2f,69,6f,2f,50,72,69,6e,74,53,74,72,65,=
61,6d,3b}; // Ljava/io/PrintStream;
		},
		{ // 0017 =3D Utf8 java/io/PrintStream
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0013;
			u1 bytes[] =3D {6a,61,76,61,2f,69,6f,2f,50,72,69,6e,74,53,74,72,65,61,=
6d}; // java/io/PrintStream
		},
		{ // 0018 =3D Utf8 println
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0007;
			u1 bytes[] =3D {70,72,69,6e,74,6c,6e}; // println
		},
		{ // 0019 =3D Utf8 (Ljava/lang/String;)V
			u1 tag =3D 01; // CONSTANT_Utf8
			u2 length =3D 0015;
			u1 bytes[] =3D {28,4c,6a,61,76,61,2f,6c,61,6e,67,2f,53,74,72,69,6e,67,=
3b,29,56}; // (Ljava/lang/String;)V
		},
		{ // 001a =3D MethodHandle getStatic java/lang/System.out:Ljava/io/Prin=
tStream;
			u1 tag =3D 0f; // CONSTANT_MethodHandle
			u1 reference_kind =3D 02; // REF_getStatic
			u2 reference_index =3D 0002; // Field java/lang/System.out:Ljava/io/Pr=
intStream;
		},
		{ // 001b =3D MethodType (Ljava/lang/String;)V
			u1 tag =3D 10; // CONSTANT_MethodType
			u2 descriptor_index =3D 0019;
		},
	};
	u2 access_flags =3D 0021; // ACC_PUBLIC | ACC_SUPER
	u2 this_class =3D 0005; // Class: HelloWorld
	u2 super_class =3D 0006; // Class: java/lang/Object
	u2 interfaces_count =3D 0000;
	u2 interfaces[interfaces_count] =3D {};
	u2 fields_count =3D 0000;
	field_info fields[fields_count] =3D {};
	u2 methods_count =3D 0002;
	method_info methods[methods_count] =3D {
		{
			u2 access_flags =3D 0001; // ACC_PUBLIC
			u2 name_index =3D 0007; // Utf8 <init>
			u2 descriptor_index =3D 0008; // Utf8 ()V
			u2 attributes_count =3D 0001;
			attribute_info attributes[attributes_count] =3D {
				{
					u2 attribute_name_index =3D 0009; // Utf8 Code
					u4 attribute_length =3D 00000011;
					u2 max_stack =3D 0001;
					u2 max_locals =3D 0001;
					u4 code_length =3D 00000005;
					u1 code[code_length] =3D {
						2a, // aload_0
						b7, 00,01, // invokespecial 0001 // Method java/lang/Object.<init>:=
()V
						b1, // return
					};
					u2 exception_table_length =3D 0000;
					exception_table_item exception_table[exception_table_length] =3D {};=

					u2 attributes_count =3D 0000;
					attribute_info attributes[attributes_count] =3D {};
				},
			};
		},
		{
			u2 access_flags =3D 0009; // ACC_PUBLIC | ACC_STATIC
			u2 name_index =3D 000a; // Utf8 main
			u2 descriptor_index =3D 000b; // Utf8 ([Ljava/lang/String;)V
			u2 attributes_count =3D 0001;
			attribute_info attributes[attributes_count] =3D {
				{
					u2 attribute_name_index =3D 0009; // Utf8 Code
					u4 attribute_length =3D 00000015;
					u2 max_stack =3D 0002;
					u2 max_locals =3D 0001;
					u4 code_length =3D 00000009;
					u1 code[code_length] =3D {
						b2, 00,02, // getstatic 0002 // Field java/lang/System.out:Ljava/io=
/PrintStream;
						12, 03, // ldc 03 // String "Hello, world!"
						b6, 00,04, // invokevirtual 0004 // Method java/io/PrintStream.prin=
tln:(Ljava/lang/String;)V
						b1, // return
					};
					u2 exception_table_length =3D 0000;
					exception_table_item exception_table[exception_table_length] =3D {};=

					u2 attributes_count =3D 0000;
					attribute_info attributes[attributes_count] =3D {};
				},
			};
		},
	};
	u2 attributes_count =3D 0000;
	attribute_info attributes[attributes_count] =3D {};
}
--------------080607050107040705030008--

--lTWmNfReFlLEt9AVjWGvWTuV60q6jjC6N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTRlVhAAoJELHSF2kinlg4u0UP/RtWBcqsJOEyUB5LWQjWPpJf
U2jnLReFdXlGenNX3vjqiQqJLcXuAqZqtQW0EhOA8gIbeyeKXV3TUcW0yP6B9u5f
zgdBLjd/H3iWjLtujFzyC6+xRW7tHv1mij5Ldad068nRslqp0B9bbegiQyP6cv+x
tECParUiD1udz1GO34DMA7GmzJlA62F1JXedLxKwICDnunJecxYabyMbTqbx+/8o
MbfX6wIJ6CZj1ywacJTfNf8xBmOWAUqoVVYweyu0n/U+ZRzPTJ937m9RqF40pW7m
loteJlkz8PNGmNXQMzL8+Iyo2740BqRS4q+v9FdCUtF1q/6lp5Bd7HXSX318dWGk
wCy8qw7kH4sHAhX23SLSLrLgUHymYEmotreZUatla5Z15WKXKLqHddtZIG1oY1Hf
gbOU1d89gIq03N2qF9qn+drCO7RIUuo7BjVsvxs4TVOTrSMHntgv+ZQXqd6vOaTu
ULkDO2aN6aGz2+PQYW+GXveVmJ01zHljRDZfieJzSWeHDpIhLtRX79oG+BONlVA8
NJrHtNKJsfAVAbJZqaaWAr1PoFmUDzTxRCYB39DV2/eWIqbf0/ssL16HVUsunpCo
243De1Eo8tj1izxHjnR2vETksedJhhLq/qfDA+ua5HahxW80qupN8EZICIDdqnP0
Y1DCIBco0M/FgdiyU3JI
=Ws42
-----END PGP SIGNATURE-----

--lTWmNfReFlLEt9AVjWGvWTuV60q6jjC6N--
